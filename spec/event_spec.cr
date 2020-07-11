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

    Fiber.yield

    event_one.handlers.size.should eq(2)
    event_two.handlers.size.should eq(2)
    event_three.handlers.size.should eq(2)
    EventQueue.stop(:test)
  end

  it "async events should be none blocking for the caller" do
    event_queue1 = EventQueue.start(:test1)
    event_queue2 = EventQueue.start(:test2)
    event1 = LockEvent.new
    event2 = LockEvent.new
    Spectrum.dispatch_async_event(event1, :test1)
    Spectrum.dispatch_async_event(event1, :test1)
    Spectrum.dispatch_async_event(event2, :test2)
    Spectrum.dispatch_async_event(event2, :test2)
    Fiber.yield
    event1.unlock!
    event2.unlock!
    Fiber.yield
    event1.unlock!
    event2.unlock!
    EventQueue.stop(:test1)
    EventQueue.stop(:test2)
  end

  it "async events should queue" do
    event_queue = EventQueue.start(name: :test, number_of_workers: 1, queue_size: 2)
    event1 = LockEvent.new
    event2 = LockEvent.new
    event3 = LockEvent.new
    Spectrum.dispatch_async_event(event1, :test)
    Spectrum.dispatch_async_event(event2, :test)
    Spectrum.dispatch_async_event(event3, :test)
    Fiber.yield
    event1.unlock!
    event2.unlock!
    event3.unlock!
    Fiber.yield
    event1.unlock!
    event2.unlock!
    event3.unlock!
    EventQueue.stop(:test)
  end

  it "async events should queue hit error if queue is full and timeout is hit" do
    event_queue = EventQueue.start(name: :test, number_of_workers: 1, queue_size: 1, queue_timeout: 0)
    event1 = LockEvent.new
    event2 = LockEvent.new
    event3 = LockEvent.new
    Spectrum.dispatch_async_event(event1, :test)
    Fiber.yield
    Spectrum.dispatch_async_event(event2, :test)
    Fiber.yield
    error = nil
    begin
      Spectrum.dispatch_async_event(event3, :test)
    rescue e : Spectrum::EventQueue::FullException
      error = e
    end
    event1.unlock!
    event2.unlock!
    event3.unlock!
    error.class.should eq(Spectrum::EventQueue::FullException)
    EventQueue.stop(:test)
  end
end
