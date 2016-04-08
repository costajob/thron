require 'spec_helper'
require 'thron/gateway/client'

describe Thron::Gateway::Client do
  let(:klass) { Thron::Gateway::Client }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/client"
  end

  it 'must call get to fetch client detail' do
    route = klass.routes.fetch(:client_detail)
    query = {
      clientId: instance.client_id
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.client_detail
  end

  it 'must call post to update audit duration days' do
    route = klass.routes.fetch(:update_audit_duration_days)
    body = {
      clientId: instance.client_id,
      auditDurationDays: 7
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_audit_duration_days(days: "7")
  end

  it 'must call post to enable secure connection' do
    route = klass.routes.fetch(:enable_secure_connection)
    body = {
      clientId: instance.client_id,
      secureConnectionEnabled: true
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.enable_secure_connection(enabled: "yes")
  end

  it 'must call post to trash older properties' do
    route = klass.routes.fetch(:trash_properties_older_than)
    body = {
      clientId: instance.client_id,
      properties: {
        removeContentsOlderThan: 5
      }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.trash_properties_older_than(days: "5")
  end
end
