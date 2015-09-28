require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'users_group_manager')

describe Thron::Gateway::FieldsOption do
  let(:klass) { Thron::Gateway::FieldsOption }

  it 'must provide a deafult factory' do
    default = klass::default
    assert default.values.all? { |attr| !attr }
  end

  it 'must return key-value form' do
    options = klass::new(true, false, true)
    options.to_h.must_equal({ returnOwnAcl: true, returnItags: false, returnImetadata: true })
  end
end

describe Thron::Gateway::Criteria do
  let(:klass) { Thron::Gateway::Criteria }

  it 'must provide a deafult factory' do
    default = klass::default
    default.ids.must_be_empty
    default.keyword.must_be_nil
    assert default.active
    default.linked_username.must_be_nil
    default.roles.must_be_empty
  end

  it 'must return key-value form' do
    options = klass::new(%w[id1 id2 id3], 'key', false, 'me', %w[role1 role2])
    options.to_h.must_equal({ ids: ['id1', 'id2', 'id3'], textSearch: 'key', active: false, linkedUsername: 'me', groupRoles: ['role1', 'role2'] })
  end
end

describe Thron::Gateway::UsersGroupManager do
  let(:klass) { Thron::Gateway::UsersGroupManager }
  let(:instance) { klass::new }

  it 'must set the package' do
    klass.package.to_s.must_equal "xsso/resources/usersgroupmanager"
  end
end
