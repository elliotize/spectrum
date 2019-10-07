require "./spec_helper"
include Spectrum
describe Spectrum do
  it "should have only events that are listening to an event recieve it" do
    event_one = FooBarOneEvent.new(id: 1)
    Spectrum.dispatch_sync_event(event_one)
    FooBarOneEventHandler.last_event.should eq(event_one)
    FooBarTwoEventHandler.last_event.should_not eq(event_one)
    FooBarBothEventHandler.last_event.should eq(event_one)
    event_two = FooBarTwoEvent.new(id: 2)
    Spectrum.dispatch_sync_event(event_two)
    FooBarOneEventHandler.last_event.should_not eq(event_two)
    FooBarTwoEventHandler.last_event.should eq(event_two)
    FooBarBothEventHandler.last_event.should eq(event_two)
    event_three = FooBarOneEvent.new(id: 3)
    Spectrum.dispatch_sync_event(event_three)
    FooBarOneEventHandler.last_event.should eq(event_three)
    FooBarTwoEventHandler.last_event.should_not eq(event_three)
    FooBarBothEventHandler.last_event.should eq(event_three)
  end

  it "async events should be triggered" do
    event_queue = EventQueue.start(:test)
    event_one = FooBarOneEvent.new(id: 1)
    Spectrum.dispatch_async_event(event_one, :test)
    while event_queue.busy?
    end
    FooBarOneEventHandler.last_event.should eq(event_one)
    FooBarTwoEventHandler.last_event.should_not eq(event_one)
    FooBarBothEventHandler.last_event.should eq(event_one)
    while event_queue.busy?
    end
    event_two = FooBarTwoEvent.new(id: 2)
    Spectrum.dispatch_async_event(event_two, :test)
    FooBarOneEventHandler.last_event.should_not eq(event_two)
    FooBarTwoEventHandler.last_event.should eq(event_two)
    FooBarBothEventHandler.last_event.should eq(event_two)
    while event_queue.busy?
    end
    event_three = FooBarOneEvent.new(id: 3)
    Spectrum.dispatch_async_event(event_three, :test)
    FooBarOneEventHandler.last_event.should eq(event_three)
    FooBarTwoEventHandler.last_event.should_not eq(event_three)
    FooBarBothEventHandler.last_event.should eq(event_three)
    EventQueue.stop(:test)
  end
end
