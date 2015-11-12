require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'contact')

describe Thron::Gateway::Contact do
  let(:klass) { Thron::Gateway::Contact }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontact/resources/contact"
  end

  it 'must call post to add contact key' do
    route = klass.routes.fetch(:add_contact_key)
    ik = entity::new(key: 'garment', value: 'blue suede shoes')
    body = {
      contactId: '666',
      ik: ik.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_contact_key(contact_id: '666', ik: ik)
  end

  it 'must call get to get contact dtail' do
    route = klass.routes.fetch(:contact_detail)
    query = {
      contactId: '666',
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.contact_detail(contact_id: '666')
  end

  it 'must call post to insert a new contact' do
    route = klass.routes.fetch(:insert_contact)
    ik = entity::new(key: 'garment', value: 'blue suede shoes')
    body = {
      value: {
        ik: ik.to_payload,
        name: 'elvis'
      }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.insert_contact(name: 'elvis', ik: ik)
  end

  it 'must call post to list existing contacts' do
    route = klass.routes.fetch(:list_contacts)
    criteria = entity::new(accessed_date_range: { from: '2015-01-01', to: '2015-10-29' }, ids: Array::new(2) { |i| "ID_#{i}" }, iks: Array::new(4) { |i| { key: "KEY_#{i}", value: "VAL_#{i}" } }, contact_type: 'PLATFORM_USER')
    options = entity::new(itags: false, keys: true, old_ids: false)
    body = {
      criteria: criteria.to_payload,
      option: options.to_payload,
      offset: 40,
      limit: 20
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.list_contacts(criteria: criteria, options: options, offset: 40, limit: 20)
  end

  it 'must call post to list existing keys' do
    route = klass.routes.fetch(:list_contact_keys)
    body = {
      criteria: {
        searchKey: 'blue suede'
      },
      offset: 0,
      limit: 100
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.list_contact_keys(search_key: 'blue suede', offset: 0, limit: 100)
  end

  it 'must call post to remove contact key' do
    route = klass.routes.fetch(:remove_contact_key)
    body = {
      contactId: '666',
      key: 'garment' 
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_contact_key(contact_id: '666', key: 'garment')
  end

  it 'must call post to update contact' do
    route = klass.routes.fetch(:update_contact)
    body = {
      contactId: '666',
      update: {
        name: 'elvis'
      }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_contact(contact_id: '666', name: 'elvis')
  end
end
