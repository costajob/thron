require 'date'
require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'behaviour', 'mappable')

module Mock
  class Entity
    def self.mappings; { first: 'firstName', last: 'lastName', dob: 'dateOfBirth' }; end
    include Thron::Mappable
  end
end

describe Thron::Mappable do
  let(:klass) { Mock::Entity }
  let(:instance) { klass::new(first: 'Elvis', last: 'Presley', dob: Date::new(1935,1,8)) }

  it 'must define accessors' do
    klass.mappings.keys.each do |message|
      instance.must_respond_to message
      instance.must_respond_to "#{message}="
    end
  end

  it 'must create an instance by data mappings' do
    data = { 
      'firstName' => 'Ringo',
      'lastName' => 'Starr',
      'dateOfBirth' => Date::new(1940,7,7),
    }
    entity = klass::factory(data)
    entity.must_be_instance_of klass
    entity.first.must_equal 'Ringo'
    entity.last.must_equal 'Starr'
    entity.dob.must_equal Date::new(1940,7,7)
  end

  it 'must return the payload form' do
    instance.to_payload.must_equal({ firstName: instance.first, lastName: instance.last, dateOfBirth: instance.dob })
  end
end
