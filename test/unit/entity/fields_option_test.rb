require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'fields_option')

describe Thron::Entity::FieldsOption do
  let(:klass) { Thron::Entity::FieldsOption }

  it 'must provide a deafult factory' do
    default = klass::default
    assert default.values.all? { |attr| !attr }
  end

  it 'must return key-value form' do
    options = klass::new(true, false, true)
    options.to_h.must_equal({ returnOwnAcl: true, returnItags: false, returnImetadata: true })
  end
end
