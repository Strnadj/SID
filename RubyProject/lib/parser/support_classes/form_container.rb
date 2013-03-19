# Form container representation
# @author Strnadj <jan.strnadek@gmail.com>

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