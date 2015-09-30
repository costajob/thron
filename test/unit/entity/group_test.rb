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
    %i[capabilities roles solutions metadata patches].each do |message|
      default.send(message).must_be_empty
    end
  end

  it 'must return payload form' do
    entity = klass::new('184f842e-8ca2-4c26-9bfd-719a85a2a73f', nil, 'PLATFORM', true, 'group_1', 'Group 1 description', %w[capability1], %w[role1 role2 role3], %w[solution1 solution2])  
    entity.to_payload.must_equal({ groupType: 'PLATFORM', active: true, groupCapabilities: { capabilities: %w[capability1], userRoles: %w[role1 role2 role3], enabledSolutions: %w[solution1 solution2] }, description: 'Group 1 description', name: 'group_1' })
  end

  it 'must add update data to payload' do
    metadata = 3.times.map { |i| Thron::Entity::Metadata::new("name#{i}", "value#{i}") }
    patches = 3.times.map { |i| Thron::Entity::Patch::new("op#{i}", "field#{i}") }
    entity = klass::new('184f842e-8ca2-4c26-9bfd-719a85a2a73f', nil, 'PLATFORM', true, 'group_1', 'Group 1 description', %w[capability1], %w[role1 role2 role3], %w[solution1 solution2], metadata, patches)
    entity.to_payload(true).must_equal({ groupType: 'PLATFORM', active: true, groupCapabilities: { capabilities: %w[capability1], userRoles: %w[role1 role2 role3], enabledSolutions: %w[solution1 solution2] }, description: 'Group 1 description', name: 'group_1', metadata: metadata.map(&:to_payload), patch: patches.map(&:to_payload) })
  end
end
