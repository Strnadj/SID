# Parser class for Penetration test
# @author Jan Strnádek <jan.strnadek@gmail.com>

require './parser/support_classes/form_container'
require 'nokogiri'
require 'open-uri'

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
      print "\t" << link['href'] << "\n" if @options[:debug]
      links << link['href']
    }

    print "Forms:" << "\n" if @options[:debug]
    doc.css('form').each {
      |form|
      type = (form['method'] == 'POST') ? FormContainer::POST_FORM : FormContainer::GET_FORM
      print "\t" << form['action'] << "\n" if @options[:debug]
    }
  end

  # Check if link is valid
  # @param [String] link  Link from a:href, form:action or JavaScript files
  def validate_link(link)
    return nil
  end
end