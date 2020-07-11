# Monkey Patch to check if channel queue is full
class Channel(T)
  def queue_full? : Bool
    if @queue
      @queue.as(Deque(T)).size == @capacity
    else
      raise "Channel does not have a queue."
    end
  end

  def sync
    @lock.sync do
      yield
    end
  end
end

module Spectrum
  class EventQueue
    @@event_queues = {} of Symbol => self

    def self.start(name : Symbol, number_of_workers : Int32 = 1, queue_size : Int32 = 1000, queue_timeout : Int32 = 30) : self | Nil
      event_handlers = EventHandlers.new
      @@event_queues[name] = self.new(event_handlers, number_of_workers, queue_size, queue_timeout)
      @@event_queues[name].start
      @@event_queues[name]
    end

    def self.stop(name : Symbol) : self | Nil
      if @@event_queues.has_key?(name)
        @@event_queues[name].stop
        @@event_queues.delete(name)
      else
        raise "Event Queue #{name} does not exist"
      end
    end

    def self.get(name : Symbol) : self
      return @@event_queues[name] if @@event_queues.has_key?(name)

      raise "Event Queue #{name} not created"
    end

    def initialize(@event_handlers : EventHandlers, @number_of_workers : Int32, queue_size : Int32, @queue_timeout : Int32)
      @queue = [] of Event
      @workers = [] of Fiber

      @channel = Channel(Event).new(queue_size)
      @state = :stopped
    end

    def send(event : Event): self
      current_time = Time.utc.to_unix
      while @channel.queue_full? && (Time.utc.to_unix - current_time) < @queue_timeout
        Fiber.yield
      end
      if @channel.queue_full?
        raise FullException.new("Channel queue of size #{@queue_timeout} is full after timeout of #{@queue_timeout}")
      end

      @channel.send(event)
      self
    end

    def running?: Bool
      @state == :running
    end

    def stopped?: Bool
      @state == :stopped
    end

    def stop: self
      @channel.close
      while workers_not_dead?
        Fiber.yield
      end
      @state = :stopped

      self
    end

    def start: self
      @state = :running

      @workers << spawn do
        begin
          while !@channel.closed?
            event = @channel.receive
            @event_handlers.on_event(event)
          end
        rescue Channel::ClosedError
        end
      end
      self
    end

    def workers_running?: Bool
      @workers.any? { |w| w.running? }
    end

    def workers_not_dead?: Bool
      @workers.any? { |w| !w.dead? }
    end

    def something?: Bool
      @workers.any? { |w| !w.resumable? }
    end

    class FullException < Exception

    end
  end
end