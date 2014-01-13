require 'helper'

describe Unfuddled::Base do

  before do
    @base = Unfuddled::Base.new(:id => 1)
  end

  describe '#[]' do
    it 'calls methods using [] with symbol' do
      expect(@base[:object_id]).to be_an Integer
    end

    it 'calls methods using [] with string' do
      expect(@base['object_id']).to be_an Integer
    end

    it 'returns nil for a missing method' do
      expect(@base[:not_really_a_method]).to be_nil
      expect(@base['not_really_a_method']).to be_nil
    end

  end

  describe '#attrs' do
    it 'returns a hash of attributes' do
      expect(@base.attrs).to eq(:id => 1)
    end
  end

end
