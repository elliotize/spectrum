# Spectrum
Travis
[![Status](https://api.travis-ci.com/elliotize/spectrum.svg?branch=master)](https://travis-ci.com/elliotize/spectrum/)  

A simple event framework using [syringe DI](https://github.com/Bonemind/syringe).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
      spectrum:
       github: elliotize/spectrum
   ```

2. Run `shards install`

## Usage

```crystal
require "spectrum"

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

  def on_event(event : FooBarOneEvent)
    # Do something
  end
end

class FooBarTwoEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def on_event(event : FooBarTwoEvent)
    # Do something
  end
end

class FooBarBothEventHandler
  include Spectrum::EventHandler
  Syringe.injectable

  def on_event(event : FooBarOneEvent)
    # Do something
  end

  def on_event(event : FooBarTwoEvent)
    # Do something
  end
end

## Sync event
event_one = FooBarOneEvent.new(id: 1)
Spectrum.dispatch_sync_event(event_one)
event_two = FooBarTwoEvent.new(id: 2)
Spectrum.dispatch_sync_event(event_two)

## Async event
Spectrum::EventQueue.start(:my_queue)
event_one = FooBarOneEvent.new(id: 1)
Spectrum.dispatch_async_event(event_one, :my_queue)
event_two = FooBarTwoEvent.new(id: 2)
Spectrum.dispatch_async_event(event_two, :my_queue)
Spectrum::EventQueue.stop(:my_queue)
```

## Contributing

1. Fork it (<https://github.com/elliotize/spectrum/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Tom Elliot](https://github.com/elliotize) - creator and maintainer
