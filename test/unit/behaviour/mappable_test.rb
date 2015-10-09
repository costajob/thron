require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'behaviour', 'mappable')

module Mock
  class Plain < Thron::Entity::Plain; end

  class Award
    def self.mappings
      @mappings ||= {
        type: Attribute::new(name: 'awardType'),
        year: Attribute::new(name: 'wonYear')
      }
    end
    include Thron::Mappable
  end

  class Spouse
    def self.mappings
      @mappings ||= {
        first: Attribute::new(name: 'firstName'),
        last: Attribute::new(name: 'lastName')
      }
    end
    include Thron::Mappable
  end

  class RockStar
    def self.mappings 
      @mappings ||= { 
        first: Attribute::new(name: 'firstName', mandatory: true),
        last: Attribute::new(name: 'lastName', mandatory: true),
        dob: Attribute::new(name: 'dateOfBirth', type: Attribute::DATE),
        grammys: Attribute::new(name: 'grammyAwards', type: Attribute::INT),
        awards: Attribute::new(name: 'wonAwards', type: [:Award]),
        spouse: Attribute::new(name: 'lastSpouse', type: :Spouse),
        mother: Attribute::new(name: 'naturalMother', type: :Plain),
        weight: Attribute::new(name: 'weightInKgs', type: Attribute::FLOAT),
        dead: Attribute::new(name: 'isDead', type: Attribute::BOOL),
        hits: Attribute::new(name: 'albumHits', type: [:Plain]),
        created_at: Attribute::new(name: 'createdAt', type: Attribute::TIME)
      }
    end
    include Thron::Mappable
  end
end

describe Thron::Mappable do
  let(:klass) { Mock::RockStar }
  let(:elvis) { { first: 'Elvis', last: 'Presley', dob: Date::new(1935,1,8), grammys: 3, awards: [1967, 1972, 1974].map { |year| Mock::Award::new(type: 'Grammy', year: year) }, spouse: Mock::Spouse::new(first: 'Priscilla', last: 'Ann Wagner'), mother: Mock::Plain::new(first: 'Gladys', last: 'Presley'), weight: 101.5, dead: true, created_at: Time::new(2015,10,29,2,0,59), :hits => [Mock::Plain::new(title: 'Elv1s', year: 2002), Mock::Plain::new(title: 'Elvis Gold', year: 2011)] } }
  let(:data) { { 'firstName' => 'Ringo', 'lastName' => 'Starr', 'dateOfBirth' => Date::new(1940,7,7).to_s, 'grammyAwards' => 10, 'wonAwards' => [1965, 1967, 1968, 1970, 1971, 1977, 1983, 1997].map { |year| { 'awardType' => 'Grammy', 'wonYear' => year } }, 'lastSpouse' => { 'firstName' => 'Barbara', 'lastName' => 'Goldbach' }, 'naturalMother' => { 'first' => 'Elsie', 'last' => 'Starkey' }, 'isDead' => 'false', 'createdAt' => Time::now.to_s, 'albumHits' => [{ 'title' => 'The Red Album', 'year' => 1973 }, { 'title' => 'The Blue Album', 'year' => 1973 }] } }
  let(:instance) { klass::new(elvis) }

  describe Thron::Mappable::Attribute do
    let(:klass) { Thron::Mappable::Attribute }

    it 'must define type constants' do
      %w[string int float list date time].each do |type|
        klass.const_get(type.upcase).must_equal type
      end
    end
  end

  it 'must return the name space' do
    klass::base_module.must_equal Mock
  end

  it 'must define accessors' do
    klass.mappings.keys.each do |message|
      instance.must_respond_to message
      instance.must_respond_to "#{message}="
    end
  end

  describe '::factory' do
    it 'must factory an instance with valid attributes' do
      entity = klass::factory(data)
      entity.must_be_instance_of klass
      entity.first.must_equal 'Ringo'
      entity.last.must_equal 'Starr'
      entity.dob.must_equal Date::new(1940,7,7)
      entity.grammys.must_equal 10
      assert entity.awards.all? { |award| award.instance_of?(Mock::Award) }
      entity.spouse.must_be_instance_of Mock::Spouse
      entity.mother.must_be_instance_of Mock::Plain
      entity.weight.must_equal 0.0
      refute entity.dead
      assert entity.hits.all? { |hit| hit.instance_of?(Mock::Plain) }
      entity.created_at.must_be_instance_of Time
    end

    it 'must factory an instance when attributes are nil' do
      data = { 
        'firstName' => 'Ringo',
        'lastName' => 'Starr',
        'grammyAwards' => nil,
        'wonAwards' => nil,
        'lastSpouse' => nil
      }
      entity = klass::factory(data)
      entity.must_be_instance_of klass
      entity.first.must_equal 'Ringo'
      entity.last.must_equal 'Starr'
      %i[awards spouse].each do |message|
        entity.send(message).must_be_nil
      end
    end

    it 'must check for mandatory attributes' do
      -> { klass::factory({}) }.must_raise klass::MissingAttributeError 
    end
  end

  describe 'constructor' do
    it 'must initialize an instance with default values' do
      entity = klass::new(first: 'George', last: 'Harrison')
      entity.must_be_instance_of klass
      entity.first.must_equal 'George'
      entity.last.must_equal 'Harrison'
      entity.dob.must_equal Date::today
      entity.grammys.must_equal 0
      entity.awards.must_be_empty
      entity.spouse.must_be_nil
      entity.weight.must_equal 0.0
      refute entity.dead
      entity.created_at.must_be_instance_of Time
    end

    it 'must check for mandatory attributes' do
      -> { klass::new({}) }.must_raise klass::MissingAttributeError 
    end
  end

  it 'must return the key-value form' do
    instance.to_h.must_equal({ 
      first: instance.first, 
      last: instance.last, 
      dob: instance.dob.to_s, 
      grammys: instance.grammys, 
      awards: instance.awards.map(&:to_h), 
      spouse: instance.spouse.to_h,
      mother: instance.mother.to_h,
      weight: instance.weight, 
      dead: instance.dead,
      hits: instance.hits.map(&:to_h),
      created_at: instance.created_at.iso8601 })
  end

  it 'must return the payload form' do
    instance.to_payload.must_equal({ 
      'firstName'     => instance.first, 
      'lastName'      => instance.last, 
      'dateOfBirth'   => instance.dob.to_s, 
      'grammyAwards'  => instance.grammys, 
      'wonAwards'     => instance.awards.map(&:to_payload), 
      'lastSpouse'    => instance.spouse.to_payload,
      'naturalMother' => instance.mother.to_h,
      'weightInKgs'   => instance.weight, 
      'isDead'        => instance.dead,
      'albumHits'     => instance.hits.map(&:to_h),
      'createdAt'     => instance.created_at.iso8601 })
  end

  it 'must discard nil key-values' do
    klass::new(first: 'John', last: 'Lennon').to_h.keys.sort.must_equal %i[created_at dead dob first grammys last weight]
  end

  describe 'equality methods' do
    let(:timestamp) { Time::now }
    let(:elvis_proc) { -> { klass::new(elvis) } }

    it 'must call the hash method on nested objects attributes' do
      elvis_proc.call.hash.must_equal elvis_proc.call.hash
    end

    it 'must define equality' do
      elvis_proc.call.must_equal elvis_proc.call
    end

    it 'must define deep equality' do
      Array::new(10) { elvis_proc.call }.uniq.must_equal [elvis_proc.call]
    end
  end
end
