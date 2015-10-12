require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity', 'base')

describe Thron::Entity::Base do
  let(:klass) { Thron::Entity::Base }
  let(:data) { { 'firstName' => 'Elvis', 'lastName' => 'Presley', 'furtherDetails' => { 'wonGrammys' => 4, 'birthDate' => '1935-01-08', 'isDead' => true }, 'studioAlbums' => [{ 'title' => 'Elvis', 'year' => 1956 }, { 'title' => 'Elvis is back!', 'year' => 1960 }, { 'title' => 'Something for everybody', 'year' => 1961 }, { 'title' => 'From Elvis in Memphis', 'year' => 1969 }, { 'title' => 'Love letters from Elvis', 'year' => 1971 }, { 'title' => 'Promised land', 'year' => 1975 } ] } }
  let(:instance) { klass::new(data) }

  it 'must map standard values' do
    instance.first_name.must_equal 'Elvis'
  end

  it 'must map hash attributes' do
    instance.further_details.must_be_instance_of klass
    instance.further_details.birth_date.must_be_instance_of Time
  end

  it 'must map array attributes' do
    instance.studio_albums.each do |album|
      album.must_be_instance_of klass
    end
  end

  it 'must return a key-value form' do
    instance.to_h.must_equal({:first_name=>"Elvis", :last_name=>"Presley", :further_details=>{:won_grammys=>4, :birth_date=>Time::new(1935,1,8), :is_dead=>true}, :studio_albums=>[{:title=>"Elvis", :year=>1956}, {:title=>"Elvis is back!", :year=>1960}, {:title=>"Something for everybody", :year=>1961}, {:title=>"From Elvis in Memphis", :year=>1969}, {:title=>"Love letters from Elvis", :year=>1971}, {:title=>"Promised land", :year=>1975}]})
  end

  it 'must return the payload form' do
    instance.to_payload.must_equal({"firstName"=>"Elvis", "lastName"=>"Presley", "furtherDetails"=>{"wonGrammys"=>4, "birthDate"=>Time::new(1935,1,8), "isDead"=>true}, "studioAlbums"=>[{"title"=>"Elvis", "year"=>1956}, {"title"=>"Elvis is back!", "year"=>1960}, {"title"=>"Something for everybody", "year"=>1961}, {"title"=>"From Elvis in Memphis", "year"=>1969}, {"title"=>"Love letters from Elvis", "year"=>1971}, {"title"=>"Promised land", "year"=>1975}]})
  end
end
