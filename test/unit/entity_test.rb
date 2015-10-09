require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'entity')

describe Thron::Entity do
  let(:klass) { Thron::Entity }
  let(:data) { { 'firstName' => 'Elvis', 'lastName' => 'Presley', 'furtherDetails' => { 'wonGrammys' => 4, 'birthDate' => '1935-01-08', 'isDead' => true } } }
  let(:instance) { klass::new(data) }

  it 'must map all values' do
    instance.first_name.must_equal 'Elvis'
    instance.further_details.must_be_instance_of klass
    instance.further_details.birth_date.must_be_instance_of Date
  end

  it 'must return a key-value form' do
    instance.to_h.must_equal({:first_name=>"Elvis", :last_name=>"Presley", :further_details=>{:won_grammys=>4, :birth_date=>Date::new(1935,1,8), :is_dead=>true}})
  end

  it 'must return the payload form' do
    instance.to_payload.must_equal({"firstName"=>"Elvis", "lastName"=>"Presley", "furtherDetails"=>{"wonGrammys"=>4, "birthDate"=>Date::new(1935,1,8), "isDead"=>true}})
  end
end
