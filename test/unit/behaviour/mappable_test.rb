require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'behaviour', 'mappable')

module Mock
  class Award
    def self.mappings
      @mappings ||= {
        name: Thron::Mappable::Attribute::new('awardName'),
        year: Thron::Mappable::Attribute::new('wonYear')
      }
    end
    include Thron::Mappable
  end

  class Spouse
    def self.mappings
      @mappings ||= {
        first: Thron::Mappable::Attribute::new('firstName'),
        last: Thron::Mappable::Attribute::new('lastName')
      }
    end
    include Thron::Mappable
  end

  class Entity
    def self.mappings 
      @mappings ||= { 
        first: Thron::Mappable::Attribute::new('firstName'),
        last: Thron::Mappable::Attribute::new('lastName'),
        dob: Thron::Mappable::Attribute::new('dateOfBirth', Thron::Mappable::Attribute::DATE),
        grammys: Thron::Mappable::Attribute::new('grammyAwards', Thron::Mappable::Attribute::INT),
        awards: Thron::Mappable::Attribute::new('wonAwards', [Mock::Award]),
        spouse: Thron::Mappable::Attribute::new('lastSpouse', Mock::Spouse),
        weight: Thron::Mappable::Attribute::new('weightInKgs', Thron::Mappable::Attribute::FLOAT),
        dead: Thron::Mappable::Attribute::new('isDead', Thron::Mappable::Attribute::BOOL),
        created_at: Thron::Mappable::Attribute::new('createdAt', Thron::Mappable::Attribute::TIME),
      }
    end
    include Thron::Mappable
  end
end

describe Thron::Mappable do
  let(:klass) { Mock::Entity }
  let(:instance) { klass::new(first: 'Elvis', last: 'Presley', dob: Date::new(1935,1,8), grammys: 3, awards: [1967, 1972, 1974].map { |year| Mock::Award::new(name: 'Grammy', year: year) }, spouse: Mock::Spouse::new(first: 'Priscilla', last: 'Ann Wagner'), weight: 101.5, dead: true, created_at: Time::new(2015,10,29,2,0,59)) }

  describe Thron::Mappable::Attribute do
    let(:klass) { Thron::Mappable::Attribute }

    it 'must define type constants' do
      %w[string int float list date time].each do |type|
        klass.const_get(type.upcase).must_equal type
      end
    end
  end

  it 'must define accessors' do
    klass.mappings.keys.each do |message|
      instance.must_respond_to message
      instance.must_respond_to "#{message}="
    end
  end

  it 'must create an instance by data mappings' do
    awards = [1965, 1967, 1968, 1970, 1971, 1977, 1983, 1997].map { |year| Mock::Award::new(name: 'Grammy', year: year) }
    spouse = Mock::Spouse::new(first: 'Barbara', last: 'Goldbach')
    data = { 
      'firstName' => 'Ringo',
      'lastName' => 'Starr',
      'dateOfBirth' => Date::new(1940,7,7),
      'grammyAwards' => 10,
      'wonAwards' => awards.map(&:to_payload),
      'lastSpouse' => spouse.to_payload,
      'weightInKgs' => 61.5,
      'isDead' => false,
      'createdAt' => Time::now
    }
    entity = klass::factory(data)
    entity.must_be_instance_of klass
    entity.first.must_equal 'Ringo'
    entity.last.must_equal 'Starr'
    entity.dob.must_equal Date::new(1940,7,7)
    entity.grammys.must_equal 10
    assert entity.awards.all? { |award| award.instance_of?(Mock::Award)}
    entity.spouse.must_be_instance_of Mock::Spouse
    entity.weight.must_equal 61.5
    refute entity.dead
    entity.created_at.must_be_instance_of Time
  end

  it 'must create a default factory' do
    entity = klass::default(last: 'Harrison')
    entity.must_be_instance_of klass
    entity.first.must_be_nil
    entity.last.must_equal 'Harrison'
    entity.dob.must_equal Date::today
    entity.grammys.must_equal 0
    entity.awards.must_be_empty
    entity.spouse.must_be_instance_of Mock::Spouse
    entity.weight.must_equal 0.0
    refute entity.dead
    entity.created_at.must_be_instance_of Time
  end

  it 'must return the key-value form' do
    instance.to_h.must_equal({ 
      first: instance.first, 
      last: instance.last, 
      dob: instance.dob.to_s, 
      grammys: instance.grammys, 
      awards: instance.awards.map(&:to_h), 
      spouse: instance.spouse.to_h,
      weight: instance.weight, 
      dead: instance.dead,
      created_at: instance.created_at.iso8601 })
  end

  it 'must return the payload form' do
    instance.to_payload.must_equal({ 
      'firstName'    => instance.first, 
      'lastName'     => instance.last, 
      'dateOfBirth'  => instance.dob.to_s, 
      'grammyAwards' => instance.grammys, 
      'wonAwards'    => instance.awards.map(&:to_payload), 
      'lastSpouse'   => instance.spouse.to_payload,
      'weightInKgs'  => instance.weight, 
      'isDead'       => instance.dead,
      'createdAt'    => instance.created_at.iso8601 })
  end
end