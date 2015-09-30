require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'fields_option')

describe Thron::Entity::FieldsOption do
  let(:klass) { Thron::Entity::FieldsOption }

  it 'must provide a deafult factory' do
    default = klass::default
    assert default.values.all? { |attr| !attr }
  end

  it 'must return payload form' do
    entity = klass::new(true, false, true)
    entity.to_payload.must_equal({ returnOwnAcl: true, returnItags: false, returnImetadata: true })
  end
end
