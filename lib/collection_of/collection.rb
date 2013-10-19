require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/object/duplicable'

class Collection
  include Enumerable

  attr_reader :klass, :options

  delegate :empty?, :size, :each, :last, to: :@collection, allow_nil: true

  class << self
    alias_method :of, :new
    alias_method :[], :new
  end

  def initialize(klass, *args)
    @options = args.extract_options!
    @klass = klass.is_a?(Class) ? klass : klass.class
    @collection = [args.first].compact.flatten
  end

  def initialize_clone(*)
    super

    # Clone each item in the collection
    @collection = @collection.inject([]) do |ary, item|
      ary << (item.duplicable? ? item.clone : item)
      ary
    end
  end

  def [](item)
    return nil if empty?

    if item.is_a?(Fixnum)
      @collection[item]
    else
      item = item.to_sym
      detect{ |i| i.name.to_sym == item }
    end
  end

  def new(*args, &block)
    @klass.new(*args, &block).tap{ |obj| @collection << obj }
  end

  def <<(obj)
    checker = @options.fetch(:allow_subclasses, true) ? :is_a? : :instance_of?
    raise ArgumentError, "can only add #{@klass.name} objects" unless obj.send(checker, @klass)
    @collection << obj
  end

  def except(*items)
    items.map!(&:to_sym)
    self.class.new(klass, reject{ |i| items.include?(i.name.to_sym) })
  end

  def ==(other)
    return other == @collection if other.is_a?(self.class)
    return @collection == other if other.is_a?(Array)
    super
  end
end