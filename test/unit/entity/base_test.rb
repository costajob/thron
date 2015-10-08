require 'test_helper'
require Thron.root.join('lib', 'thron', 'entity', 'base')

describe Thron::Entity::Base do
  let(:klass) { Thron::Entity::Base }
  let(:args) { %w[first last age] }

  it 'must create simple string mappings' do
    Thron::Entity::Base::mappings = args
    klass::mappings = args
    klass::mappings.each do |k, v| 
      v.name.must_equal k.to_s
      v.type.must_equal Thron::Mappable::Attribute::STRING
      refute v.mandatory
    end
  end
end
