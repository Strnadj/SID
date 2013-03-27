# Form container representation
# @author Strnadj <jan.strnadek@gmail.com>

require 'open-uri'

module Parser
  class FormContainer
    # Class attributes
    attr_accessor :type, :params, :action

    # Post form
    POST_FORM = :post

    # Get form
    GET_FORM  = :get

    # Select type
    SELECT = :select

    # Initiate of form container
    # @param [Hash] attr Attributes
    def initialize(attr)
      @type   = attr[:type]
      @params = attr[:params]
      @action = attr[:action]
    end

    # Get form attributes
    # @return [Hash] attributes
    def get_attr
      # Prepare request parameters
      request_params = Hash.new

      # Interate through params
      for a in 0..(@params.count - 1)
        param = @params[a]

        # Checkbox?
        if param[:type] == "checkbox"
          request_params[param[:name]] = "1"
        elsif param[:type] == "select"
          request_params[param[:name]] = param[:values][0]
        else
          request_params[param[:name]] = "test"
        end
      end

      request_params
    end

    # Get FORM URI
    # @return [URI] Form url
    def get_uri

      # Create URI
      ret = URI(@action.to_s)

      # Create parameters
      ret.query = URI.encode_www_form(self.get_attr)

      ret
    end

    # Equals method for comparing
    # @param [FormContainer] another_form_container Another form container
    # @return [boolean] True or false
    def ==(another_form_container)
      # Action URL
      return false if @action != another_form_container.action

      # Different type
      return false if @type != another_form_container.type

      # Parameters
      return false if @params != another_form_container.params

      # Everything ok!
      return true
    end

    # Alias for ==
    alias eql? ==

    # Override to string method
    # @return [String] String representation of form
    def to_s
      "Form:\n\tAction: " << @action << "\n\tParams: " << @params.to_s << "\n\tType: " << @type.to_s
    end

  end
end