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
    rules = 3.times.map { |i| Thron::Entity::AclRule::new(target_id: i, target_class: "class#{i}", enabled: %w[rule1 rule2], disabled: %w[rule3]) }
    entity = klass::new('context1', rules)
    entity.to_payload.must_equal({ onContext: 'context1', rules: rules.map(&:to_payload) })
  end
end
