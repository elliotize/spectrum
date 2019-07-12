module Spectrum
  class EventDispatcher
    def self.dispatch_event(event : Event)
      listeners = EventListeners.new
      listeners.on_event(event)
    end
  end
end