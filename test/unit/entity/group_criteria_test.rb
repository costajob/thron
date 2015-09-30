require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'group_criteria')

describe Thron::Entity::GroupCriteria do
  let(:klass) { Thron::Entity::GroupCriteria }

  it 'must provide a deafult factory' do
    default = klass::default
    assert default.active
    default.acl.must_equal Thron::Entity::Acl::default
    %i[keyword linked_username type owner external_id].each do |message|
      default.send(message).must_be_nil
    end
    %i[ids roles solutions].each do |message|
      default.send(message).must_be_empty
    end
  end

  it 'must return payload form' do
    acl = Thron::Entity::Acl::new('context1', [])
    entity = klass::new(%w[id1 id2 id3], 'foo', false, 'linked', %w[role1 role2], %w[solution1], acl, 'type 1', 'owner', 'external')
    entity.to_payload.must_equal({ ids: %w[id1 id2 id3], textSearch: 'foo', active: false, linkedUsername: 'linked', groupRoles: %w[role1 role2], usersEnabledSolutions: %w[solution1], acl: acl.to_payload, groupType: 'type 1', ownerUsername: 'owner', externalId: 'external' })
  end
end
