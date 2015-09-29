require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'acl')

describe Thron::Entity::Acl do
  let(:klass) { Thron::Entity::Acl }

  it 'must provide a deafult factory' do
    default = klass::default
    default.on_context.must_be_nil
    default.rules.must_be_empty
  end

  it 'must return key-value form' do
    options = klass::new('context1', %w[rule1 rule2])
    options.to_h.must_equal({ onContext: 'context1', rules: %w[rule1 rule2] })
  end
end
