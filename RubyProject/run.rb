# Pen Test - in ruby
# @author Jan Strnadek <jan.strnadek@gmail.com>

require './parser/parser'
require './helpers/prompts'
require './tester/url_tester'

# Print help when there is no arguments on command line
print_help() if ARGV.length == 0

# Options array
options = {}
options[:base_url] = nil
options[:depth_level] = 0
options[:full_domain] = 0
options[:output_text] = nil
options[:error_directive] = true
options[:debug] = true

# Parse arguments from command line
options[:base_url] = ARGV.at(0)

#ARGV.each do|a|
#  puts "Argument: #{a}"
#end

# Create parser
parser = UrlParser.new(options)

# Run parser
parser.start_parsing()

# Get result
result = parser.get_results()

# Create tester
url_tester = UrlTester.new(result)




