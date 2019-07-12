module Spectrum
  class EventDispatcher
    def dispatch_event(event : Event)
      listeners = EventHandlers.new
      listeners.on_event(event)
    end
  end
end