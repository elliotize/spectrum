require "spec"
require "../src/spectrum"

class FooBarOneEvent
  include Spectrum::Event
  getter :handlers
  def initialize(@id : Int32)
    @handlers = [] of Spectrum::EventHandler
  end

  def store_handler(handler : Spectrum::EventHandler)
    @handlers << handler
  end
end

class FooBarTwoEvent
  include Spectrum::Event
  getter :handlers
  def initialize(@id : Int32)
    @handlers = [] of Spectrum::EventHandler
  end

  def store_handler(handler : Spectrum::EventHandler)
    @handlers << handler
  end
end

class FooBarOneEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def on_event(event : FooBarOneEvent)
    event.store_handler(self)
  end
end

class FooBarTwoEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def on_event(event : FooBarTwoEvent)
    event.store_handler(self)
  end
end

class FooBarBothEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def on_event(event : FooBarOneEvent)
    event.store_handler(self)
  end

  def on_event(event : FooBarTwoEvent)
    event.store_handler(self)
  end
end