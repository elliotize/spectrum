module Spectrum
  class EventQueue
    include Syringe

    @@event_queues = {} of Symbol => self
    @fiber : Fiber | Nil

    def self.start(name : Symbol) : self | Nil
      @@event_queues[name] = self.new
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

    def initialize(event_handlers : EventHandlers)
      @event_handlers = event_handlers
      @channel = Channel(Event).new
      @state = :stopped
      @runner_state = :not_running
      @fiber = nil
    end

    def send(event : Event): self
      @channel.send(event)
      self
    end

    def running?: Bool
      @state == :running
    end

    def stopped?: Bool
      @state = :stopped
    end

    # This is hinting that the fiber should be within a runner
    # class
    def stop: self
      @state = :stopped
      if @fiber.is_a?(Fiber)
        while @fiber.as(Fiber).running?
        end
        self
      else
        raise "This queue was never started" 
      end
    end

    def start: self
      @state = :running
      @fiber = spawn do
        while running?
          event = @channel.receive
          @runner_state = :running
          @event_handlers.on_event(event)
          @runner_state = :not_running
        end
      end
      self
    end

    def events_in_queue?: Bool
      !@channel.empty?
    end

    def processing_an_event?: Bool
      @runner_state == :running
    end

    def busy?: Bool
      running? && events_in_queue? && processing_an_event?
    end
  end
end