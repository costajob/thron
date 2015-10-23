require 'test_helper'
require Thron.root.join('lib', 'thron', 'response')

describe Thron::Response do
  let(:klass) { Thron::Response }
  let(:ok) { OpenStruct::new(code: 200, parsed_response: { 'ssoCode' => '657', 'field1' => 'Elvis', 'field2' => 'Presley', 'resultCode' => 'OK', 'totalResults' => 66 }) }
  let(:ko_key) { OpenStruct::new(code: 404, parsed_response: { 'errorDescription' => 'Not found' }) }
  let(:ko_keys) { OpenStruct::new(code: 400, parsed_response: { 'actionsInError' => %w[action1 action2 action5]}) }
  let(:ko_str) { OpenStruct::new(code: 400, parsed_response: 'Forbidden') }
  let(:id) { OpenStruct::new(code: 200, parsed_response: '08fce2d6-d4d8-4906-a8a1-5dcf4bd3f671') }
  let(:unparsed) { OpenStruct::new(code: 200) }

  describe '200' do
    let(:instance) { klass::new(ok) }

    it 'must initialize state' do
      %i[http_code body result_code sso_code total error].each do |attr|
        assert instance.instance_variable_defined?(:"@#{attr}")
      end
    end

    it 'must respond to accessors' do
      %i[http_code body result_code sso_code total error].each do |message|
        instance.must_respond_to message
      end
    end

    it 'must remove response keys and leave body data' do
      instance.body.must_equal({ "field1" => "Elvis", "field2" => "Presley" })
    end

    it 'must valorize other response keys' do
      instance.result_code.must_equal 'OK'
      instance.sso_code.must_equal '657'
      instance.total.must_equal 66
    end

    it 'must valorize body data for matching ID data' do
      instance = klass::new(id)
      instance.body.must_equal({ id: id.parsed_response })
    end

    it 'must set body attribute only for 200 responses' do
      instance.body = :data
      instance.body.must_equal :data
    end

    it 'must set attributes to nil if response is unparsed' do
      instance = klass::new(unparsed)
      %i[result_code sso_code error].each do |message|
        instance.send(message).must_be_nil
      end
    end

  end

  describe 'non 200' do
    it 'must valorize single key error' do
      instance = klass::new(ko_key)
      instance.error.must_equal 'Not found'
    end

    it 'must valorize multiple keys error' do
      instance = klass::new(ko_keys)
      instance.error.must_equal %w[action1 action2 action5]
    end

    it 'must valorize string error' do
      instance = klass::new(ko_str)
      instance.error.must_equal 'Forbidden'
    end

    it 'must prevent set of body attribute for non-200 responses' do
      instance = klass::new(ko_str)
      instance.body = :data
      instance.body.must_equal({})
    end
  end
end
