require 'spec_helper'
require 'thron/entity/base'

describe Thron::Entity::Base do
  let(:klass) { Thron::Entity::Base }
  let(:data) { { 'creationTime' => '2014-05-26T07:54:22.499Z', 'firstName' => 'Elvis', 'lastName' => 'Presley', 'furtherDetails' => { 'wonGrammys' => 4, 'birthDate' => '1935-01-08', 'isDead' => true }, 'studioAlbums' => [{ 'title' => 'Elvis', 'year' => 1956 }, { 'title' => 'Elvis is back!', 'year' => 1960 }, { 'title' => 'Something for everybody', 'year' => 1961 }, { 'title' => 'From Elvis in Memphis', 'year' => 1969 }, { 'title' => 'Love letters from Elvis', 'year' => 1971 }, { 'title' => 'Promised land', 'year' => 1975 } ] } }
  let(:instance) { klass::new(data) }

  it 'must factory an instance' do
    args = { firstName: 'George', lastName: 'Harrison' }
    instance = klass::factory(args)
    instance.must_be_instance_of klass
    instance.first_name.must_equal args.fetch(:firstName)
    instance.last_name.must_equal args.fetch(:lastName)
  end

  it 'must factory a list of instances' do
    args = Array::new(5) { |i| { firstName: "first#{i}", lastName: "last#{i}" } }
    instances = klass::factory(args)
    assert instances.all? { |instance| instance.must_be_instance_of klass }
  end

  it 'must map standard values' do
    instance.first_name.must_equal 'Elvis'
  end

  it 'must map hash attributes' do
    instance.further_details.must_be_instance_of klass
    instance.creation_time.must_be_instance_of Time
    instance.further_details.birth_date.must_be_instance_of Date
  end

  it 'must map array attributes' do
    instance.studio_albums.each do |album|
      album.must_be_instance_of klass
    end
  end

  it 'must return a key-value form' do
    instance.to_h.must_equal({:creation_time=>instance.creation_time.iso8601, :first_name=>"Elvis", :last_name=>"Presley", :further_details=>{:won_grammys=>4, :birth_date=>instance.further_details.birth_date.iso8601, :is_dead=>true}, :studio_albums=>[{:title=>"Elvis", :year=>1956}, {:title=>"Elvis is back!", :year=>1960}, {:title=>"Something for everybody", :year=>1961}, {:title=>"From Elvis in Memphis", :year=>1969}, {:title=>"Love letters from Elvis", :year=>1971}, {:title=>"Promised land", :year=>1975}]})
  end

  it 'must return the payload form' do
    instance.to_payload.must_equal({"creationTime"=>instance.creation_time.iso8601, "firstName"=>"Elvis", "lastName"=>"Presley", "furtherDetails"=>{"wonGrammys"=>4, "birthDate"=>instance.further_details.birth_date.iso8601, "isDead"=>true}, "studioAlbums"=>[{"title"=>"Elvis", "year"=>1956}, {"title"=>"Elvis is back!", "year"=>1960}, {"title"=>"Something for everybody", "year"=>1961}, {"title"=>"From Elvis in Memphis", "year"=>1969}, {"title"=>"Love letters from Elvis", "year"=>1971}, {"title"=>"Promised land", "year"=>1975}]})
  end
end
