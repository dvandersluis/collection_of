require 'benchmark/ips'
require 'collection_of'

Item = Struct.new(:name)

Benchmark.ips do |x|
  @collection = Collection.of(Item)
  @collection << Item.new(:foo)
  @collection << Item.new(:bar)
  @collection << Item.new(:baz)

  @array = []
  @array << Item.new(:foo)
  @array << Item.new(:bar)
  @array << Item.new(:baz)

  x.report('collection') do
    @collection[:baz]
  end

  x.report('array') do
    @array.detect { |i| i.name == :baz }
  end

  x.compare!
end
