require 'collection_of'

class Widget
  attr_accessor :name

  def initialize(name = nil)
    @name = name
  end
end

class Wadget
  attr_accessor :name

  def initialize
    @name = yield if block_given?
  end
end

class SubWidget < Widget; end

describe Collection do
  let(:w) { Widget.new }

  describe "#initialize" do
    context "when using #new" do
      subject { Collection.new(Widget, [w], allow_subclasses: true) }
      it { should be_a Collection }
      it { should == [w] }
      its(:klass) { should == Widget }
      its(:options) { should == { allow_subclasses: true } }
    end

    context "when using the CollectionOf[] shorthand" do
      subject { CollectionOf[Widget, [w], allow_subclasses: true] }
      it { should be_a Collection }
      it { should == [w] }
      its(:klass) { should == Widget }
      its(:options) { should == { allow_subclasses: true } }
    end

    context "when using the Collection[] shorthand" do
      subject { Collection[Widget, [w], allow_subclasses: true] }
      it { should be_a Collection }
      it { should == [w] }
      its(:klass) { should == Widget }
      its(:options) { should == { allow_subclasses: true } }
    end

    context "when using Collection.of" do
      subject { Collection.of(Widget, [w], allow_subclasses: true) }
      it { should be_a Collection }
      it { should == [w] }
      its(:klass) { should == Widget }
      its(:options) { should == { allow_subclasses: true } }
    end
  end

  describe "#clone" do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    before { c << w1 << w2 }

    subject { c.clone }

    it { should_not == c }
    its(:first) { should_not == c.first }
    its([1]) { should_not == c.first }

    its('first.name') { should == :one }
  end

  describe "#[]" do
    let(:w) { Widget.new("widgey") }
    subject{ described_class.new(Widget) }

    context "when the collection is empty" do
      its([:foo]) { should be_nil }
    end

    context "when the collection is not empty" do
      before { subject << w }

      its([0]) { should == w }
      its(['widgey']) { should == w }
      its([:widgey]) { should == w }
      its([1]) { should be_nil }
      its([:fake]) { should be_nil }
    end
  end

  describe "#new" do
    subject { described_class[Widget] }

    it "should create a new Widget" do
      subject.new.should be_a Widget
    end

    it "should add it to the collection" do
      subject.new
      subject.count.should == 1
    end

    it "should add the new item to the end of the collection" do
      3.times { subject.new }
      w = subject.new
      subject[3].should == w
    end

    it "should pass on any arguments" do
      w = subject.new('Smith')
      w.name.should == 'Smith'
    end

    it "should pass on a given block" do
      c = described_class[Wadget]
      w = c.new { :test }
      w.name.should == :test
    end
  end

  describe "#<<" do
    subject { described_class[Widget] }

    it "should add like types to the collection" do
      expect { subject << w }.to_not raise_error
      subject.first.should == w
    end

    it "should not add unlike types to the collection" do
      w = Wadget.new
      expect { subject << w }.to raise_error(ArgumentError, "can only add Widget objects")
    end

    it "should add subclasses" do
      expect { subject << SubWidget.new }.to_not raise_error
    end

    it "should not allow subclasses if allow_subclasses is false" do
      c = described_class[Widget, allow_subclasses: false]
      expect { c << SubWidget.new }.to raise_error(ArgumentError, "can only add Widget objects")
    end
  end

  describe "#keys" do
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }
    subject { described_class[Widget] }

    before { subject << w1 << w2 }

    its(:keys) { should == [:one, :two] }
  end

  describe "#key?" do
    let(:w1) { Widget.new(:one) }
    subject { described_class[Widget] }

    before { subject << w1 }

    it { should have_key(:one) }
    it { should_not have_key(:two) }
  end

  describe "#include?" do
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:one) }
    subject { described_class[Widget] }
    before { subject << w1 }

    it { should include w1 }
    it { should include :one }
    it { should_not include w2 }
    it { should_not include :two }
  end

  describe "#except" do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    before { c << w1 << w2 }

    context "when an include item is specified" do
      subject { c.except(:one) }
      it { should be_a described_class }
      it { should == [w2] }
    end

    context "when all included items are specified" do
      subject { c.except(:one, :two) }
      it { should be_a described_class }
      it { should be_empty }
    end

    context "when no included items are specified" do
      subject { c.except(:three) }
      it { should be_a described_class }
      it { should == [w1, w2] }
    end
  end

  describe "#slice" do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    before { c << w1 << w2 }

    context "when an include item is specified" do
      subject { c.slice(:one) }
      it { should be_a described_class }
      it { should == [w1] }
    end

    context "when all included items are specified" do
      subject { c.slice(:one, :two) }
      it { should be_a described_class }
      it { should == [w1, w2] }
    end

    context "when no included items are specified" do
      subject { c.slice(:three) }
      it { should be_a described_class }
      it { should be_empty }
    end
  end

  describe "#==" do
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    subject { described_class[Widget] }
    before { subject << w1 << w2 }

    it { should == [w1, w2] }
    it { should_not == [w1] }
    it { should_not == [w2] }
    it { should_not == [] }

    it { should == described_class[Widget, [w1, w2]] }
    it { should_not == described_class[Widget, [w1]] }
    it { should_not == described_class[Widget, [w2]] }
    it { should_not == described_class[Widget] }
  end
end