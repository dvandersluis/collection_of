# CollectionOf

Provides an Enumerable which acts as a collection of a certain type of object (and its subclasses,
unless `allow_subclasses` is set to `false` on initialization).

## Usage

    WidgetCollection = Collection[Widget]
    # OR WidgetCollection = Collection.of(Widget)
    # OR WidgetCollection = Collection.new(Widget)

    wc = WidgetCollection.new
    wc << Widget.new # all good!
    wc << Wadget.new # => ArgumentError, "can only add Widget objects"

When a `Collection` is cloned, any items contained within the collection are cloned as well.

    wc << Widget.new(:one)
    wc << Widget.new(:two)
    wc[:one] == wc.clone[:one] # => false

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
