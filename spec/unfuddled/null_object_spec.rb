require 'helper'

describe Unfuddled::NullObject do

  describe '#to_a' do
    it 'returns an empty Array' do
      expect(subject.to_a).to be_an Array
      expect(subject.to_a).to be_empty
    end
  end

  describe '#to_ary' do
    it 'returns an empty Array' do
      expect(subject.to_ary).to be_an Array
      expect(subject.to_ary).to be_empty
    end
  end

  describe '#method_missing' do
    it 'returns itself' do
      expect(subject.method_missng).to be_an Unfuddled::NullObject
    end
  end

  if RUBY_VERSION < '1.9'
    describe '#respond_to?' do
      it 'should always return true' do
        expect(subject.respond_to? :foo).to be_true
        expect(subject.respond_to? :to_a).to be_true
        expect(subject.respond_to? :to_s).to be_true
      end
    end
  else
    describe '#respond_to_missing?' do
      it 'should always return true' do
        expect(subject.respond_to? :foo).to be_true
        expect(subject.respond_to? :to_a).to be_true
        expect(subject.respond_to? :to_s).to be_true
      end
    end
  end


  if RUBY_VERSION >= '1.9'
    describe '#to_c' do
      it 'returns a complex number of value zero' do
        expect(subject.to_c).to be_a Complex
        expect(subject.to_c).to be_zero
      end
    end

    describe '#to_r' do
      it 'returns a rational number of value zero' do
        expect(subject.to_r).to be_a Rational
        expect(subject.to_r).to be_zero
      end
    end

    if RUBY_VERSION >= '2.0'
      describe '#to_h' do
        it 'returns an empty Hash' do
          expect(subject.to_h).to be_a Hash
          expect(subject.to_h).to be_empty
        end
      end
      
      describe '#to_f' do
        it 'returns zero as floating point (0.0)' do
          expect(subject.to_f).to be_a Float
          expect(subject.to_f).to be_zero
        end
      end

      describe '#to_i' do
        it 'returns zero as an integer (0)' do
          expect(subject.to_i).to be_an Integer
          expect(subject.to_i).to be_zero
        end
      end

      describe '#to_s' do
        it 'returns an empty string ""' do
          expect(subject.to_s).to be_a String
          expect(subject.to_s).to be_empty
        end
      end
    end
  end
end
