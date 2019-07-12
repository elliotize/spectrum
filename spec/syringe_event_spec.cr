require "./spec_helper"

describe Spectrum do
  it "should have only events that are listening to an event recieve it" do
    event_one = FooBarOneEvent.new(id: 1)
    Spectrum::EventDispatcher.dispatch_event(event_one)
    FooBarOneEventHandler.last_event.should eq(event_one)
    FooBarTwoEventHandler.last_event.should_not eq(event_one)
    FooBarBothEventHandler.last_event.should eq(event_one)
    event_two = FooBarTwoEvent.new(id: 2)
    Spectrum::EventDispatcher.dispatch_event(event_two)
    FooBarOneEventHandler.last_event.should_not eq(event_two)
    FooBarTwoEventHandler.last_event.should eq(event_two)
    FooBarBothEventHandler.last_event.should eq(event_two)
    event_three = FooBarOneEvent.new(id: 3)
    Spectrum::EventDispatcher.dispatch_event(event_three)
    FooBarOneEventHandler.last_event.should eq(event_three)
    FooBarTwoEventHandler.last_event.should_not eq(event_three)
    FooBarBothEventHandler.last_event.should eq(event_three)
  end
end
