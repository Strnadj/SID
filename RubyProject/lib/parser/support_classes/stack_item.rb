# Stack item for Links and Level
# @author Strnadj <jan.strnadek@gmail.com>

module Parser
  class StackItem
    attr_accessor :url, :level

    def initialize(variable)
      @url = variable[:url]
      @level = variable[:level]
    end
  end
end