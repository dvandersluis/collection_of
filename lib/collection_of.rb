require 'collection_of/version'
require 'collection_of/collection'

module CollectionOf
  def self.[](klass, *args)
    Collection.of(klass, *args)
  end
end
