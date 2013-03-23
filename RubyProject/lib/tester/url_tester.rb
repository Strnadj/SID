# Class for url penetration testing
# @author Strnadj <jan.strnadek@gmail.com>

require 'net/http'

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

    # Method for start test
    def start_test()
      print "= Start testing: =\n".bold.green if @options[:debug]

      # Parse links
      puts "Test links:".bold.red << "\n" if options[:debug]
      @parser_results[:links].each {
        |link|

      }

      # Parse get forms
      puts "Test get forms:".bold.green << "\n" if @options[:debug]
      @parser_results[:get_forms].each {
        |form|

      }

      # Parse post forms
      puts "Test post forms:".bold.green << "\n" if @options[:debug]
      @parser_results[:post_forms].each {
        |form|

      }

    end

    # Send get request with specified parameters
    # @param [URI] uri Request url
    # @return [String] Response body
    # @param [Hash] attr Attributes
    def get_request(uri, attr)
      getData = Net::HTTP.get(uri, attr)
      return getData.body
    end

    # Send post request with specified parameters
    # @param [URI] uri Request url
    # @return [String] Response body
    # @param [Hash] attr Attributes
    def post_request(uri, attr)
      postData = Net::HTTP.post_form(uri, attr)
      return postData.body
    end


    # Compare results from two pages
    # @param [String] before Before change tags
    # @param [String] after  After change parameter
    # @return [Boolean] True or false if there is suspicion for SQLi
    def compare_results(before, after)
      if options[:error_directive]
        # True - try to find ERROR message on site
      else
        # False - try to compare results on page
      end
    end

  end
end