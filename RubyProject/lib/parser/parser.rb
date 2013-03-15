# Parser class for Penetration test
# @author Strnadj <jan.strnadek@gmail.com>

require "#{File.dirname(__FILE__)}/support_classes/form_container"
require "#{File.dirname(__FILE__)}/support_classes/a_container"
require 'nokogiri'
require 'open-uri'

module Parser
  class UrlParser
    attr_accessor :links, :post_forms, :get_forms, :start_url, :url_stack, :options

    # Initialization of Parser class
    # @param [Hash] options  Options
    def initialize(options)
      @links      = Array.new
      @post_forms = Array.new
      @get_forms  = Array.new
      @start_url  = options[:base_url]
      @url_stack  = Array.new
      @options    = options
    end

    # Start parsing url
    def start_parsing()
      print "Start parsing\n" if @options[:debug]
      @url_stack << @start_url
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
        current_url = @url_stack.pop
        print "Parsing: " << current_url << "\n" if @options[:debug]
        self.parse_url(current_url)
      end
    end


    # Parse URL and get form, links etc..
    # @param [String] current_url Curent URL
    def parse_url(current_url)
      # Open URL via Nokogiri
      doc = Nokogiri::HTML(open(current_url))

      # Iterate links
      print "Links:" << "\n" if @options[:debug]
      doc.css('a').each{
        |link|
        if link['href']
          valid_link = self.validate_link(current_url, link['href'])
          print "\t" << valid_link.to_s << "\n" if @options[:debug]
          # Create link container if not exist, or add parameters to exist link container
          exist_container = nil
          @links.each { |link|
            link.url == valid_link.to_s
            exist_container = link
            break
          }
          if exist_container != nil

          else
            new_link = Parser::AContainer.new({ :url => valid_link.to_s, :attr => Array.new })
          end
          # Add link container to links
          links << link['href']
        end
      }

      print "Forms:" << "\n" if @options[:debug]
      doc.css('form').each {
        |form|
        type = (form['method'] == 'POST') ? FormContainer::POST_FORM : FormContainer::GET_FORM
      }
    end

    def create_param_array(link)

    end

    # Method for clear and validate link
    # @param [String] current_url Current URL
    # @param [String] link        A form link
    # @return [URI] Uri instance without fragment
    def validate_link(current_url, link)
      valid_link = URI(URI.join(current_url, link).to_s)
      valid_link.fragment =  nil # Remove fragment!!
      valid_link
    end
  end
end