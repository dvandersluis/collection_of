require 'collection_of/collection'
require 'collection_of/version'

module CollectionOf
  def self.[](klass, *args)
    Collection.of(klass, *args)
  end
end
