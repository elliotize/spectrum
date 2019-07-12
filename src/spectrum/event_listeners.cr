require "syringe"
module Spectrum
  class EventListeners
    include Syringe

    def initialize(@listeners : Array(EventListener))
    end

    def on_event(event : Event)
      @listeners.each do |listener|
        listener.on_event(event)
      end
    end
  end
end