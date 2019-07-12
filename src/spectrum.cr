require "./spectrum/*"
module Spectrum
  def self.dispatch_event(event : Event)
    dispatcher = EventDispatcher.new
    dispatcher.dispatch_event(event)
  end
end
