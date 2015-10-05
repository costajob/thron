require 'test_helper'
require Thron::root.join('lib', 'thron', 'gateway', 'session')

describe Thron::Gateway::Session do
  let(:klass) { Thron::Gateway::Session }

  it 'must raise an exception when no token_id is present' do
    -> { klass::new(client_id: 'client') }.must_raise Thron::Gateway::NoActiveSessionError
  end

  it 'must initialize state' do
    instance = klass::new(token_id: 'my_token')
    %i[client_id token_id].each do |attr|
      assert instance.instance_variable_defined?(:"@#{attr}")
    end
  end
end
