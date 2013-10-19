# CollectionOf

TODO: Write a gem description

## Usage

    WidgetCollection = CollectionOf[Widget]
    WidgetCollection = Collection.of(Widget)

    wc = WidgetCollection.new
    wc << Widget.new # all good!
    wc << Wadget.new # => ArgumentError, "can only add Widget objects"

## Installation

Add this line to your application's Gemfile:

    gem 'collection_of'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collection_of

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
