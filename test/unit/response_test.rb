require 'test_helper'
require Thron.root.join('lib', 'thron', 'response')

describe Thron::Response do
  let(:klass) { Thron::Response }
  let(:ok) { OpenStruct::new(code: 200, parsed_response: { "ssoCode" => "657", "field1" => "Elvis", "field2" => "Presley", "resultCode" => "OK", "totalResults" => 66 }) }
  let(:ko) { OpenStruct::new(code: 400, parsed_response: 'Forbidden') }
  let(:unparsed) { OpenStruct::new(code: 200) }

  describe '200' do
    let(:instance) { klass::new(ok) }

    it 'must initialize state' do
      %i[http_code body result_code sso_code total error].each do |attr|
        assert instance.instance_variable_defined?(:"@#{attr}")
      end
    end

    it 'must remove response keys and leave data' do
      instance.body.must_equal({ "field1" => "Elvis", "field2" => "Presley" })
    end

    it 'must detect 200 http code' do
      assert instance.is_200?
    end
  end

  it 'must valorize error' do
    instance = klass::new(ko)
    instance.error.must_equal 'Forbidden'
  end

  it 'must set attributes to nil if response is unparsed' do
    instance = klass::new(unparsed)
    %i[result_code sso_code error].each do |message|
      instance.send(message).must_be_nil
    end
  end
end
