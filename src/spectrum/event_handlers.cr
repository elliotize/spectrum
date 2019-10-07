require "syringe"
module Spectrum
  class EventHandlers
    include Syringe
    Syringe.injectable

    def initialize(@handlers : Array(EventHandler))
    end

    def on_event(event : Event)
      @handlers.each do |handler|
        handler.on_event(event)
      end
    end
  end
end