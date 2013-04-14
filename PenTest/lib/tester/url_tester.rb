# Class for url penetration testing
# @author Strnadj <jan.strnadek@gmail.com>

require 'net/http'
require 'open-uri'

module ContentTester
  class UrlTester
    attr_accessor :parser_results, :options

    # Constructor of UrlTester class
    # @param [Hash] parser_results Parser results
    # @param [Hash] options        Options from CLI
    def initialize(parser_results, options)
      @parser_results = parser_results
      @options = options
    end

    # Create url
    # @param [String] url URL
    # @param [Array] parameters Parameters
    # @return [URI] URI reference
    def create_url(url, parameters)
      ret = URI(url)
      ret.query = URI.encode_www_form(parameters)
      return ret
    end

    # Link testing
    # @return nil
    def test_links()
     # Parse links
        puts "Test links:".bold.red << "\n" if options[:debug]
        @parser_results[:links].each {
            |link|
            attr = link.attr

            puts "\tTest: ".yellow.bold << link.url << "\n" if @options[:debug]

            for i in 0..(attr.count - 1)
              # Copy array
              attr_c = Marshal.load(Marshal.dump(attr))

              # Add to paramaetr test case
              attr_c[i][1] += "'"

              # Try to get page
              original = get_request(link.get_uri())
              test_res = get_request(create_url(link.url, attr_c))

              # Test 404 error
              if original[:code] == 404 || test_res[:code] == 404
                puts "\t\tError: ".red.bold << "404 - not found" << "\n" if @options[:debug]
                next
              end

              # Test parameters
              if self.compare_results(original[:body], test_res[:body])
                puts "\t\tParam: ".red.bold << attr_c[i][0] << " - probably " << "UNSECURED".bold.red << "\n"  if @options[:debug]
                puts "\t\t" << create_url(link.url, attr_c).to_s << "\n\n" if @options[:debug]
              end
            end
      }
    end

    # Method for testing get forms
    # @return nil
    def test_get_forms()
      # Parse get forms
      puts "Test get forms:".bold.green << "\n" if @options[:debug]
      @parser_results[:get_forms].each {
        |form|

        # Debug output
        puts "\tTest: ".yellow.bold << form.action << "\n" if @options[:debug]

        # Iterate parameters
        for i in 0..(form.params.count - 1)
          # Create test request
          test_request = Hash.new

          # In i is argument for substitution
          for a in 0..(form.params.count - 1)
            param = form.params[a]

            # Checkbox?
            if param[:type] == "checkbox"
              if a == i
                test_request[param[:name]] = "1'"
              else
                test_request[param[:name]] = "1"
              end
            elsif param[:type] == "select"
              if a == i
                test_request[param[:name]] = param[:values][0] + "'"
              else
                test_request[param[:name]] = param[:values][0]
              end
            else
              if a == i
                test_request[param[:name]] = "test'"
              else
                test_request[param[:name]] = "test"
              end
            end
          end

          # Param array ready
          original = get_request(form.get_uri())
          test_res = get_request(create_url(form.action, test_request))

          # Test 404 error
          if original[:code] == 404 || test_res[:code] == 404
            puts "\t\tError: ".red.bold << "404 - not found" << "\n" if @options[:debug]
            next
          end

          # Test parameters
          puts original[:body] << "\n"
          puts test_res[:body] << "\n"
          if self.compare_results(original[:body], test_res[:body])
            puts "\t\tParam: ".red.bold << attr_c[i][0] << " - probably " << "UNSECURED".bold.red << "\n"  if @options[:debug]
            puts "\t\t" << create_url(link.url, attr_c).to_s << "\n\n" if @options[:debug]
          end
        end
      }
    end

    # Method for testing post forms
    # @return nil
    def test_post_forms()
        
    end

    # Method for start test
    # @return nil
    def start_test()
      print "= Start testing: =\n".bold.green if @options[:debug]

      # Run start testing a
      test_links()

   
      # Parse post forms
      puts "Test post forms:".bold.green << "\n" if @options[:debug]
      @parser_results[:post_forms].each {
        |form|

        # Debug output
        puts "\tTest: ".yellow.bold << form.action << "\n" if @options[:debug]

        # Iterate parameters
        for i in 0..(form.params.count - 1)
          # Create test request
          test_request = Hash.new

          # Parametr name
          param_name = ""

          # In i is argument for substitution
          for a in 0..(form.params.count - 1)
            param = form.params[a]

            # Checkbox?
            if param[:type] == "checkbox"
              if a == i
                param_name = param[:name]
                test_request[param[:name]] = "1'"
              else
                test_request[param[:name]] = "1"
              end
            elsif param[:type] == "select"
              if a == i
                param_name = param[:name]
                test_request[param[:name]] = param[:values][0] + "'"
              else
                test_request[param[:name]] = param[:values][0]
              end
            else
              if a == i
                param_name = param[:name]
                test_request[param[:name]] = "test'"
              else
                test_request[param[:name]] = "test"
              end
            end
          end

          # Param array ready
          post_uri = URI(form.action)
          original = post_request(post_uri, form.get_attr())
          test_res = post_request(post_uri, test_request)

          # Test 404 error
          if original[:code] == 404 || test_res[:code] == 404
            puts "\t\tError: ".red.bold << "404 - not found" << "\n" if @options[:debug]
            next
          end

          # Test parameters
          if self.compare_results(original[:body], test_res[:body])
            puts "\t\tParam: ".red.bold << param_name << " - probably " << "UNSECURED".bold.red << "\n"  if @options[:debug]
            puts "\t\t" << post_uri.to_s << "(attr: " << test_request.to_s << ")\n\n" if @options[:debug]
          end
        end
      }

    end

    # Send get request with specified parameters
    # @param [URI] uri Request url
    # @return [String] Response body
    def get_request(uri)
      ret = Hash.new
      size = 1000
      http = Net::HTTP.new(uri.host, uri.port)
      headers = {
          'Range' => "bytes=#{size}-"
      }
      path = uri.to_s.empty? ? "/" : uri.to_s

      ret[:code] = http.head(path, headers).code.to_i

      ret[:body] = Net::HTTP.get_response(uri).body

      ret
    end

    # Send post request with specified parameters
    # @param [URI] uri Request url
    # @return [String] Response body
    # @param [Hash] attr Attributes
    def post_request(uri, attr)
      ret = Hash.new
      size = 1000
      http = Net::HTTP.new(uri.host, uri.port)
      headers = {
          'Range' => "bytes=#{size}-"
      }
      path = uri.to_s.empty? ? "/" : uri.to_s

      ret[:code] = http.head(path, headers).code.to_i

      ret[:body] = Net::HTTP.post_form(uri, attr).body

      ret
    end


    # Compare results from two pages
    # @param [String] before Before change tags
    # @param [String] after  After change parameter
    # @return [Boolean] True or false if there is suspicion for SQLi
    def compare_results(before, after)
      if options[:error_directive]
        # True - try to find ERROR message on site
        return (after.include? "Warning: mysql_") ||  (after.include? "Error: mysql_") ||  (after.include? "Fatal Error: mysql_") || (after.include? "error: mysql_")
      else
        # False - try to compare results on page
      end
    end

  end
end
