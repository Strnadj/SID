# Parser class for Penetration test
# @author Strnadj <jan.strnadek@gmail.com>

require_relative './support_classes/form_container'
require_relative './support_classes/a_container'
require_relative './support_classes/stack_item'

require 'nokogiri'
require 'open-uri'
require 'colored'
require 'public_suffix'

module Parser
  class UrlParser
    attr_accessor :links, :post_forms, :get_forms, :start_url, :url_stack, :options, :url_host, :url_history, :trd_host

    # Initialization of Parser class
    # @param [Hash] options  Options
    def initialize(options)
      @links      = Array.new
      @post_forms = Array.new
      @get_forms  = Array.new
      @url_stack  = Array.new
      @url_history= Array.new
      @start_url  = options[:base_url]
      @options    = options

      # get url domain via PublicSuffix
      host = URI(@start_url).host
      if host == "localhost"
        @url_host = host
        @trd_host = nil # Nil means there is no TRD record
      else
        domain = PublicSuffix.parse(URI(@start_url).host)
        @url_host = domain.sld
        @trd_host = domain.trd == 'www' ? nil : domain.trd
      end
    end

    # Start parsing url
    def start_parsing()
      print " = Start parsing: = \n".bold.green if @options[:debug]
      @url_stack << Parser::StackItem.new({ :url => @start_url, :level => 0})
      self.run()
    end

    # Return parser scan results
    # @return [Hash] Result
    def get_results()
      ret = {}
      ret[:links]      = @links
      ret[:post_forms] = @post_forms
      ret[:get_forms]  = @get_forms
      ret
    end

    # Run parsing method
    def run()
      while @url_stack.length > 0
        current_stack_item = @url_stack.pop

        # Add to url history
        @url_history << current_stack_item

        # Count temporary items on page
        links_count = @links.count()
        forms_count = @post_forms.count() + @get_forms.count()

        # Print debug
        print "Parsing: ".red << current_stack_item.url.green << "\n" if @options[:debug]

        # Start parsing
        ret = self.parse_url(current_stack_item.url, current_stack_item.level + 1)

        # Print debug
        if @options[:debug] && ret
          print "Founded:\n\t".bold.yellow << (@links.count() - links_count).to_s << " links" << "\n\t" << (@post_forms.count() + @get_forms.count() - forms_count).to_s << " forms\n"
        end
      end
    end


    # Parse URL and get form, links etc..
    # @param [String] current_url  Curent URL
    # @param [Integer] depth_level Level
    def parse_url(current_url, depth_level)
      # Open URL via Nokogiri
      begin
        doc = Nokogiri::HTML(open(current_url))
      rescue => e
        # Bad code - show debug and return
        puts "\tError: ".bold.red << e.message << "\n"
        return nil
      end

      # Debug output link search
      puts "Links:".bold.yellow << "\n" if @options[:debug]

      # Iterate links
      doc.css('a').each{
        |link|
        if link['href']
          # Validate link
          valid_link = self.validate_link(current_url, link['href'])

          # Skip bad links
          next unless valid_link

          # Skip links, which are already in stack?!
          unless add_url_to_stack(valid_link, depth_level)
            next
          end

          # Extract query data
          query_params = URI::decode_www_form(valid_link.query) if valid_link.query

          # Remove query part
          valid_link.query = nil

          # Create link container if not exist, or add parameters to exist link container
          exist_index     = nil
          @links.each_with_index { |link, index|
            exist_index = index if link.url == valid_link.to_s
          }
          if exist_index != nil
            @links[exist_index].extends_params(query_params) if query_params
          else
            new_link = Parser::AContainer.new({ :url => valid_link.to_s, :attr => query_params })
            # add link to container
            @links.push(new_link)
          end
        end
      }

      # Debug output form search
      puts "Forms:".bold.yellow << "\n" if @options[:debug]

      # Iterate forms
      doc.css('form').each {
        |form|

        # Get type
        type = (form['method'] == 'POST') ? Parser::FormContainer::POST_FORM : Parser::FormContainer::GET_FORM

        # Get action link
        valid_link = self.validate_link(current_url, form['action'])

        # Skip invalid links
        next unless valid_link

        # Add to stack
        add_url_to_stack(valid_link, depth_level)

        # Inputs, select array
        attributes = Array.new

        # Get properties
        form.css('input').each {
          |input|
          attributes << { :name => input['name'], :type => input['type'] } if input['name']
        }

        form.css('select').each {
          |select|

          # Values array
          values = Array.new

          # Get values
          select.css('option').each {
            |option|
            values << option['value'] if option['value']
          }

          attributes << { :name => select['name'], :type => Parser::FormContainer::SELECT, :values => values } if select['name']
        }

        # Create form container
        form = Parser::FormContainer.new({ :action => valid_link.to_s, :type => type, :params => attributes })

        # Try if there is in form array exactly the same form! If there is not
        if type == Parser::FormContainer::GET_FORM
          form_exist = false
          @get_forms.each {
            |tForm|
            form_exist = true if tForm == form
          }
          @get_forms << form unless form_exist
        else
          form_exist = false
          @post_forms.each {
            |tForm|
            form_exist = true if tForm == form
          }
          @post_forms << form unless form_exist
        end
      }

      return true
    end

    # Add url to searching stack
    # @param [URI] valid_link Valid link
    # @param [Integer] depth_level Level of depth
    # @return [nil] Nothing
    def add_url_to_stack(valid_link, depth_level)
      # Test on host
      if valid_link.host == "localhost"
        test_sld = "localhost"
      else
        begin
          ps_temp = PublicSuffix.parse(valid_link.host)
          test_sld = ps_temp.sld
          test_trd = ps_temp.trd == 'www' ? nil : ps_temp.trd # WWW = NIL!
        rescue  => e
          puts "\tERROR TEST_SLD: ".red.bold << valid_link.host.to_s << " - " << e.message << "\n"
          return false
        end
      end

      if test_sld != @url_host
        puts "\tSkip: " << valid_link.to_s.red << ' - out of server!' << "\n" if @options[:debug]
        return false
      end

      # If full domain options is false - follow only same TRD
      if !@options[:full_domain] && @trd_host != test_trd
        puts "\tSkip: " << valid_link.to_s.red << ' - out of TRD domain!' << "\n" if @options[:debug]
        return false
      end

      # Add to stack
      if @options[:depth_level] == 0 || @options[:depth_level] >= depth_level

        # Exist link?!
        exist_in_stack = false
        @url_stack.each {
            |item|
          exist_in_stack = true if item.url == valid_link.to_s
        }

        @url_history.each  {
            |item|
          exist_in_stack = true if item.url == valid_link.to_s
        }

        @url_stack << Parser::StackItem.new({:url => valid_link.to_s, :level => depth_level}) unless exist_in_stack
        puts "\t" << valid_link.to_s unless exist_in_stack
      end

      return true
    end


    # Method for clear and validate link
    # @param [String] current_url Current URL
    # @param [String] link        A form link
    # @return [URI] Uri instance without fragment
    def validate_link(current_url, link)
      begin
        valid_link = URI.join(current_url, URI.encode(link))
        valid_link.fragment =  nil # Remove fragment!!

        # Add WWW? when valid_link is not localhost and www is missing (trd = nil)
        if valid_link.host != 'localhost'
          if PublicSuffix.parse(valid_link.host).trd == nil
            valid_link.host = 'www.' + valid_link.host
          end
        end
      rescue
        puts "\tERROR: ".red << current_url << " - " << link << "\n"
        return false
      end

      return valid_link
    end
  end
end