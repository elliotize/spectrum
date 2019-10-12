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
  include Spectrum::EventHandler
  Syringe.injectable

  def self.last_event=(event : FooBarOneEvent)
    @@eventFooBarOne = event
  end

  def self.last_event
    @@eventFooBarOne
  end

  def on_event(event : FooBarOneEvent)
    self.class.last_event = event
  end
end

class FooBarTwoEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def self.last_event=(event : FooBarTwoEvent)
    @@eventFooBarTwo = event
  end

  def self.last_event
    @@eventFooBarTwo
  end

  def on_event(event : FooBarTwoEvent)
    self.class.last_event = event
  end
end

class FooBarBothEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def self.last_event=(event : Spectrum::Event)
    @@eventFooBarBoth = event
  end

  def self.last_event
    @@eventFooBarBoth
  end

  def on_event(event : FooBarOneEvent)
    self.class.last_event = event
  end

  def on_event(event : FooBarTwoEvent)
    self.class.last_event = event
  end
end