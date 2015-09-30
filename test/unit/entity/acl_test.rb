require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'acl')

describe Thron::Entity::Acl do
  let(:klass) { Thron::Entity::Acl }

  it 'must provide a deafult factory' do
    default = klass::default
    default.on_context.must_be_nil
    default.rules.must_be_empty
  end

  it 'must return the payload form' do
    entity = klass::new('context1', %w[rule1 rule2])
    entity.to_payload.must_equal({ onContext: 'context1', rules: %w[rule1 rule2] })
  end
end
