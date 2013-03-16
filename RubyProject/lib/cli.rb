# Pen Test - in ruby
# @author Jan Strnadek <jan.strnadek@gmail.com>

require "#{File.dirname(__FILE__)}/parser/parser"
require "#{File.dirname(__FILE__)}/tester/url_tester"

require 'optparse'
require 'ostruct'
require 'open-uri'

module PenTest
  class CLI
    # Start CLI interface, parse options etc..
    # @return [nil] Nothing
    def self.start()
    # Parse options from cmd
    options = OptParse.parse(ARGV)

    # Create parser
    parser = Parser::UrlParser.new(options)

    # Run parser
    parser.start_parsing()

    # Get result
    result = parser.get_results()

    # Create tester
    url_tester = UrlTester.new(result)

    # Exit
    exit 0
    end
  end

  # Option parser
  class OptParse
    def self.parse(args)
      # Options specified from cmd
      options = {}
      options[:base_url] = nil
      options[:depth_level] = 0
      options[:full_domain] = true
      options[:output_text] = nil
      options[:error_directive] = true
      options[:debug] = false

      # Base URL! - non-optional parameter!
      opts = OptionParser.new do |opts|
        opts.banner = "Welcome to SID - SQL Injection Detector script\n\tAuthor: Strnadj <jan.strnadek@gmail.com>\n\tAgreement: Only for studding purposes!\n\nUsage: ./pentest [options]"

        opts.separator ''
        opts.separator 'Required options:'

        # Required argument - URL
        opts.on('-u', '--url URL', 'Required base URL') do |url|
          options[:base_url] = url
        end

        opts.separator ''
        opts.separator 'Specific options:'

        # Depth level
        opts.on('-l', '--depth-level N', Integer, 'Depth level (default 0 - all levels)') do |level|
          options[:depth_level] = level
        end

        opts.on('-d', '--debug BOOL', 'Debug output (default FALSE)') do |debug|
          options[:debug] = debug
        end

        opts.on('-f', '--full-domain [BOOL]', 'Full domain (wildcards http://*.web.com/ - default TRUE)') do |fd|
          options[:full_domain] = fd
        end

        opts.on('-o', '--output [FILENAME]', 'File for text output (default NULL)') do |filename|
          options[:output_text] = filename
        end

        opts.on('-e', '--error-directive [BOOL]', 'Error directive E~ALL (if false - experimental behaviour - default TRUE)') do |directive|
          options[:error_directive] = directive
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this help') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Show version') do
          print 'PenTest 0.1\n'
          exit
        end
      end

      opts.parse!(args)

      # Check required argument - BASE URL
      if !options[:base_url]
        puts opts
        exit
      end

      options
    end
  end
end



