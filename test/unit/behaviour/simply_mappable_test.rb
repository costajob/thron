require 'test_helper'
require Thron.root.join('lib', 'thron', 'behaviour', 'simply_mappable')

module Mock
  class RockBand
    include Thron::SimplyMappable
    self.mappings = %w[name members genere]
  end
end

describe Thron::SimplyMappable do
  let(:klass) { Mock::RockBand }

  it 'must create simple string mappings' do
    klass::mappings.each do |k, v| 
      v.name.must_equal k.to_s
      v.type.must_equal Thron::Mappable::Attribute::STRING
      refute v.mandatory
    end
  end
end
