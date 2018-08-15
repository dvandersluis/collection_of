require 'rspec/its'
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

  describe '#initialize' do
    context 'when using #new' do
      subject { Collection.new(Widget, [w], allow_subclasses: true) }
      it { is_expected.to be_a Collection }
      it { is_expected.to eq([w]) }
      its(:klass) { is_expected.to eq(Widget) }
      its(:options) { is_expected.to eq(allow_subclasses: true) }
    end

    context 'when using the CollectionOf[] shorthand' do
      subject { CollectionOf[Widget, [w], allow_subclasses: true] }
      it { is_expected.to be_a Collection }
      it { is_expected.to eq([w]) }
      its(:klass) { is_expected.to eq(Widget) }
      its(:options) { is_expected.to eq(allow_subclasses: true) }
    end

    context 'when using the Collection[] shorthand' do
      subject { Collection[Widget, [w], allow_subclasses: true] }
      it { is_expected.to be_a Collection }
      it { is_expected.to eq([w]) }
      its(:klass) { is_expected.to eq(Widget) }
      its(:options) { is_expected.to eq(allow_subclasses: true) }
    end

    context 'when using Collection.of' do
      subject { Collection.of(Widget, [w], allow_subclasses: true) }
      it { is_expected.to be_a Collection }
      it { is_expected.to eq([w]) }
      its(:klass) { is_expected.to eq(Widget) }
      its(:options) { is_expected.to eq(allow_subclasses: true) }
    end
  end

  describe '#clone' do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    before { c << w1 << w2 }

    subject { c.clone }

    it { is_expected.not_to eq(c) }
    its(:first) { is_expected.to_not eq(c.first) }
    its([1]) { is_expected.to_not eq(c.first) }

    its('first.name') { is_expected.to eq(:one) }
  end

  describe '#[]' do
    let(:w) { Widget.new('widgey') }
    subject { described_class.new(Widget) }

    context 'when the collection is empty' do
      its([:foo]) { is_expected.to be_nil }
    end

    context 'when the collection is not empty' do
      before { subject << w }

      its([0]) { is_expected.to eq(w) }
      its(['widgey']) { is_expected.to eq(w) }
      its([:widgey]) { is_expected.to eq(w) }
      its([1]) { is_expected.to be_nil }
      its([:fake]) { is_expected.to be_nil }
    end
  end

  describe '#new' do
    subject { described_class[Widget] }

    it 'creates a new Widget' do
      expect(subject.new).to be_a Widget
    end

    it 'adds it to the collection' do
      subject.new
      expect(subject.count).to eq(1)
    end

    it 'adds the new item to the end of the collection' do
      3.times { subject.new }
      w = subject.new
      expect(subject[3]).to eq(w)
    end

    it 'passes on any arguments' do
      w = subject.new('Smith')
      expect(w.name).to eq('Smith')
    end

    it 'passes on a given block' do
      c = described_class[Wadget]
      w = c.new { :test }
      expect(w.name).to eq(:test)
    end
  end

  describe '#<<' do
    subject { described_class[Widget] }

    it 'adds like types to the collection' do
      expect { subject << w }.to_not raise_error
      expect(subject.first).to eq(w)
    end

    it 'raises an error if trying to add a different type to the collection' do
      w = Wadget.new
      expect { subject << w }.to raise_error(ArgumentError, 'can only add Widget objects')
    end

    it 'adds subclasses' do
      expect { subject << SubWidget.new }.to_not raise_error
    end

    it 'does not allow subclasses if allow_subclasses is false' do
      c = described_class[Widget, allow_subclasses: false]
      expect { c << SubWidget.new }.to raise_error(ArgumentError, 'can only add Widget objects')
    end
  end

  describe '#keys' do
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }
    subject { described_class[Widget] }

    before { subject << w1 << w2 }

    its(:keys) { is_expected.to eq(%i[one two]) }
  end

  describe '#key?' do
    let(:w1) { Widget.new(:one) }
    subject { described_class[Widget] }

    before { subject << w1 }

    it { is_expected.to have_key(:one) }
    it { is_expected.not_to have_key(:two) }
  end

  describe '#include?' do
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:one) }
    subject { described_class[Widget] }
    before { subject << w1 }

    it { is_expected.to include w1 }
    it { is_expected.to include :one }
    it { is_expected.not_to include w2 }
    it { is_expected.not_to include :two }
  end

  describe '#except' do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    before { c << w1 << w2 }

    context 'when an include item is specified' do
      subject { c.except(:one) }
      it { is_expected.to be_a described_class }
      it { is_expected.to eq([w2]) }
    end

    context 'when all included items are specified' do
      subject { c.except(:one, :two) }
      it { is_expected.to be_a described_class }
      it { is_expected.to be_empty }
    end

    context 'when no included items are specified' do
      subject { c.except(:three) }
      it { is_expected.to be_a described_class }
      it { is_expected.to eq([w1, w2]) }
    end
  end

  describe '#slice' do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    before { c << w1 << w2 }

    context 'when an include item is specified' do
      subject { c.slice(:one) }
      it { is_expected.to be_a described_class }
      it { is_expected.to eq([w1]) }
    end

    context 'when all included items are specified' do
      subject { c.slice(:one, :two) }
      it { is_expected.to be_a described_class }
      it { is_expected.to eq([w1, w2]) }
    end

    context 'when no included items are specified' do
      subject { c.slice(:three) }
      it { is_expected.to be_a described_class }
      it { is_expected.to be_empty }
    end
  end

  describe '#==' do
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    subject { described_class[Widget] }
    before { subject << w1 << w2 }

    it { is_expected.to eq([w1, w2]) }
    it { is_expected.not_to eq([w1]) }
    it { is_expected.not_to eq([w2]) }
    it { is_expected.not_to eq([]) }

    it { is_expected.to eq(described_class[Widget, [w1, w2]]) }
    it { is_expected.not_to eq(described_class[Widget, [w1]]) }
    it { is_expected.not_to eq(described_class[Widget, [w2]]) }
    it { is_expected.not_to eq(described_class[Widget]) }
  end

  describe '#delete' do
    let(:c) { described_class[Widget] }
    let(:w1) { Widget.new(:one) }
    let(:w2) { Widget.new(:two) }

    subject { c }

    before { c << w1 << w2 }

    context 'when an included item is specified' do
      before { c.delete(:one) }
      it { is_expected.to eq([w2]) }
    end

    context 'when all included items are specified' do
      before { c.delete(:one, :two) }
      it { is_expected.to be_empty }
    end

    context 'when no included items are specified' do
      before { c.delete(:three) }
      it { is_expected.to eq([w1, w2]) }
    end
  end
end
