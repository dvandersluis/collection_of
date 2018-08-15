require 'benchmark/ips'
require 'collection_of'

Item = Struct.new(:name)

Benchmark.ips do |x|
  @collection = Collection.of(Item)
  @array = []

  x.report('collection') do
    @collection << Item.new(:foo)
  end

  x.report('array') do
    @array << Item.new(:foo)
  end

  x.compare!
end
