# Container for links
# @author Strnadj <jan.strnadek@gmail.com>

module Parser
  class AContainer
    # Attributes
    attr_accessor :url, :attr

    # Constructor
    # @param [Hash] args Hash field arguments
    def initialize(args)
      @url = args[:url]
      @attr = args[:attr]
    end

    # Extends array for next params
    # @param [Hash] param_array array with params
    # @return nil
    def extends_params(param_array)
      @attr = @attr.concat(param_array)
      @attr.uniq! { |s| s.first }
    end

    # To string for debug purposes
    def to_s
      ret = {}
      ret[:url] = @url
      ret[:attr] = @attr.to_s
      ret.to_s
    end
  end
end