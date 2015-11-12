require 'test_helper'
require Thron.root.join('lib', 'thron', 'gateway', 'access_manager')

describe Thron::Gateway::AccessManager do
  let(:klass) { Thron::Gateway::AccessManager }
  let(:instance) { klass::new }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/accessmanager"
  end

  describe 'API methods' do
    let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
    let(:response) { OpenStruct::new(code: 200, parsed_response: { 'tokenId' => token_id, 'resultCode' => 'OK' }) }

    it 'must raise an exception when calling session-based APIs without token' do
      %i[logout validate_capabilities validate_roles validate_token].each do |message|
        -> { instance.send(message) }.must_raise Thron::Gateway::NoActiveSessionError
      end
    end

    describe '#login' do
      it 'must call post to login' do
        route = klass.routes.fetch(:login)
        username, password = 'elvis', 'presley'
        query = { username: username, password: password }
        mock(klass).post(route.url, { query: query, body: {}, headers: route.headers }) { response }
        instance.login(username: username, password: password) 
      end

      it 'must set the token_id' do
        stub(klass).post { response }
        instance.token_id.must_be_nil
        instance.login(username: 'elvis', password: 'preseley')
        instance.token_id.must_equal token_id
      end
    end

    it 'must reset the token_id on logout' do
      stub(klass).post { response }
      instance.token_id = token_id
      instance.logout
      instance.token_id.must_be_nil
    end

    it 'must call post to logout' do
      route = klass.routes.fetch(:logout)
      mock(klass).post(route.url, { query: {}, body: {}, headers: route.headers(token_id: token_id) }) { response }
      instance.token_id = token_id
      instance.logout
    end

    it 'must call post to validate capabilities' do
      route = klass.routes.fetch(:validate_capabilities)
      capabilities = %w[CS-TURUOI CS-RETYVR CS-OZ704N]
      query = {
        capabilities: capabilities.join(',')
      }
      mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id) }) { response }
      instance.token_id = token_id
      instance.validate_capabilities(capabilities: capabilities)
    end

    it 'must call post to validate roles' do
      route = klass.routes.fetch(:validate_roles)
      roles = %w[CS-DEL8GH_MANAGER CS-CRBSR2_APP_EDITOR CS-46XMHE_APP_EDITOR]
      query = {
        role: roles.join('|')
      }
      mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id) }) { response }
      instance.token_id = token_id
      instance.validate_roles(roles: roles, xor: true)
    end

    it 'must call post to validate token' do
      route = klass.routes.fetch(:validate_token)
      query = {
        username: 'elvis'
      }
      mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id) }) { response }
      instance.token_id = token_id
      instance.validate_token(username: 'elvis')
    end
  end
end
