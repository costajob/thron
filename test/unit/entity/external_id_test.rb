require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'external_id')

describe Thron::Entity::ExternalId do
  let(:klass) { Thron::Entity::ExternalId }

  it 'must provide a deafult factory' do
    default = klass::default
    %i[id type].each do |message|
      default.send(message).must_be_nil
    end
  end

  it 'must return the payload form' do
    entity = klass::new('id1', 'type1')
    entity.to_payload.must_equal({ id: 'id1', externalType: 'type1' })
  end
end
