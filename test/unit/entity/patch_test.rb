require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'patch')

describe Thron::Entity::Patch do
  let(:klass) { Thron::Entity::Patch }

  it 'must provide a deafult factory' do
    default = klass::default
    %i[op field].each do |message|
      default.send(message).must_be_nil
    end
  end

  it 'must return the payload form' do
    entity = klass::new('op1', 1000)
    entity.to_payload.must_equal entity.to_h
  end
end
