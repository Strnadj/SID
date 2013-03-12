# Form container representation
class FormContainer
  # Class attributes
  attr_accessor :type, :params, :action

  # Post form
  POST_FORM = :post

  # Get form
  GET_FORM  = :get

  # Initiate of form container
  # @param [String] type Type of form
  # @param [URL] action  Url of action
  def initialize(type, action)
     case type
       when POST_FORM, GET_FORM
         @type = type
       else raise('Invalid form type')
     end

     @params = Array.new
     @action = action
  end

end