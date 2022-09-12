require "delegate"

module BandwidthIris
  class PaginatedResult < SimpleDelegator
    def initialize(items, links, &block)
      super(items)
      @links = links
      @requestor = block
    end

    def next
      return unless @links && @links[:next]

      @requestor.call(@links[:next].match(/\<([^>]+)\>/)[1].sub(/^http.*\/v1.0/, ""))
    end
  end
end
