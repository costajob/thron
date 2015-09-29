require 'test_helper'
require Thron.root.join('lib', 'thron', 'gateway', 'access_manager')

describe Thron::Gateway::AccessManager do
  let(:klass) { Thron::Gateway::AccessManager }
  let(:instance) { klass::new }

  it 'must set the package' do
    klass.package.to_s.must_equal "xsso/resources/accessmanager"
  end

  describe 'API methods' do
    let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
    let(:response) { OpenStruct::new(parsed_response: { 'tokenId' => token_id, 'resultCode' => 'OK' }) }

    it 'must raise an exception when calling session-based APIs without token' do
      %i[logout validate_capabilities validate_roles validate_token].each do |message|
        -> { instance.send(message) }.must_raise Thron::Gateway::NoActiveSessionError
      end
    end

    describe '#login' do
      it 'must call post to login' do
        route = instance.routes.fetch(:login)
        username, password = 'username', 'password'
        query = { username: username, password: password }
        mock(klass).post(route.url, { query: query, body: {}, headers: route.headers }) { response }
        instance.login(username: username, password: password) 
      end

      it 'must set the token_id' do
        stub(klass).post { response }
        instance.token_id.must_be_nil
        instance.login
        instance.token_id.must_equal token_id
      end
    end

    it 'must reset the token_id on logout' do
      stub(klass).post { response }
      instance.token_id = token_id
      instance.logout
      instance.token_id.must_be_nil
    end

    { logout: {}, validate_capabilities: { capabilities: '' }, validate_roles: { role: '' }, validate_token: {} }.each do |message, query|
      it "must call post to #{message}" do
        route = instance.routes.fetch(message)
        mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id) })
        instance.token_id = token_id
        instance.send(message)
      end
    end
  end
end
