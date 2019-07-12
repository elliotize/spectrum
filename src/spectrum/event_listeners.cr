require "syringe"
module Spectrum
  class EventHandlers
    include Syringe

    def initialize(@listeners : Array(EventHandler))
    end

    def on_event(event : Event)
      @listeners.each do |listener|
        listener.on_event(event)
      end
    end
  end
end