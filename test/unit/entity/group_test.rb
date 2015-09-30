require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'group')

describe Thron::Entity::Group do
  let(:klass) { Thron::Entity::Group }

  it 'must provide a deafult factory' do
    default = klass::default
    refute default.active
    default.name.must_equal 'default'
    %i[id external_id type description].each do |message|
      default.send(message).must_be_nil
    end
    %i[acl_rules capabilities roles solutions metadata patches].each do |message|
      default.send(message).must_be_empty
    end
    default.created_at.must_be_instance_of Time
  end

  it 'must return payload form' do
    entity = klass::new('184f842e-8ca2-4c26-9bfd-719a85a2a73f', nil, 'PLATFORM', true, 'group_1', 'Group 1 description', nil, [], %w[capability1], %w[role1 role2 role3], %w[solution1 solution2], [], [])
    entity.to_payload.must_equal({ groupType: 'PLATFORM', active: true, groupCapabilities: { capabilities: %w[capability1], userRoles: %w[role1 role2 role3], enabledSolutions: %w[solution1 solution2] }, description: 'Group 1 description', name: 'group_1', metadata: [], patch: [] })
  end
end
