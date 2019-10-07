module Spectrum
  class EventDispatcher
    def dispatch_sync_event(event : Event)
      listeners = EventHandlers.new
      listeners.on_event(event)
    end

    def dispatch_async_event(event : Event, queue_name : Symbol)
      event_queue = EventQueue.get(queue_name)
      event_queue.send(event)
    end
  end
end