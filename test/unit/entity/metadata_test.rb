require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'metadata')

describe Thron::Entity::Metadata do
  let(:klass) { Thron::Entity::Metadata }

  it 'must provide a deafult factory' do
    default = klass::default
    %i[name value].each do |message|
      default.send(message).must_be_nil
    end
  end

  it 'must return the payload form' do
    entity = klass::new('score', 1000)
    entity.to_payload.must_equal entity.to_h
  end
end
