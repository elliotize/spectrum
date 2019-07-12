require "spec"
require "../src/spectrum"

class FooBarOneEvent
  include Spectrum::Event
  def initialize(@id : Int32)
  end
end

class FooBarTwoEvent
  include Spectrum::Event
  def initialize(@id : Int32)
  end
end

class FooBarOneEventHandler
  include Spectrum::EventListener
  Syringe.injectable

  def self.last_event=(event : FooBarOneEvent)
    @@event = event
  end

  def self.last_event
    @@event
  end

  def on_event(event : FooBarOneEvent)
    self.class.last_event = event
  end
end

class FooBarTwoEventHandler
  include Spectrum::EventListener
  Syringe.injectable

  def self.last_event=(event : FooBarTwoEvent)
    @@event = event
  end

  def self.last_event
    @@event
  end

  def on_event(event : FooBarTwoEvent)
    self.class.last_event = event
  end
end

class FooBarBothEventHandler
  include Spectrum::EventListener
  Syringe.injectable

  def self.last_event=(event : Spectrum::Event)
    @@event = event
  end

  def self.last_event
    @@event
  end

  def on_event(event : FooBarOneEvent)
    self.class.last_event = event
  end

  def on_event(event : FooBarTwoEvent)
    self.class.last_event = event
  end
end