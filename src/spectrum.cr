require "./spectrum/*"
module Spectrum
  def self.dispatch_sync_event(event : Event)
    dispatcher = EventDispatcher.new
    dispatcher.dispatch_sync_event(event)
  end

  def self.dispatch_async_event(event : Event, queue_name : Symbol = :main)
    dispatcher = EventDispatcher.new
    dispatcher.dispatch_async_event(event, queue_name)
  end
end
