require "./spec_helper"
include Spectrum
describe Spectrum do
  it "should have only events that are listening to an event recieve it" do
    event_one = FooBarOneEvent.new(id: 1)
    event_two = FooBarTwoEvent.new(id: 2)
    event_three = FooBarOneEvent.new(id: 3)

    Spectrum.dispatch_sync_event(event_one)
    Spectrum.dispatch_sync_event(event_two)
    Spectrum.dispatch_sync_event(event_three)

    event_one.handlers.size.should eq(2)
    event_two.handlers.size.should eq(2)
    event_three.handlers.size.should eq(2)
  end

  it "async events should be triggered" do
    event_queue = EventQueue.start(:test)
    event_one = FooBarOneEvent.new(id: 1)
    event_two = FooBarTwoEvent.new(id: 2)
    event_three = FooBarOneEvent.new(id: 3)

    Spectrum.dispatch_async_event(event_one, :test)
    Spectrum.dispatch_async_event(event_two, :test)
    Spectrum.dispatch_async_event(event_three, :test)
    while event_queue.busy?
      # This is just a loop to ensure there is not a race condition
    end
    event_one.handlers.size.should eq(2)
    event_two.handlers.size.should eq(2)
    event_three.handlers.size.should eq(2)
    EventQueue.stop(:test)
  end
end
