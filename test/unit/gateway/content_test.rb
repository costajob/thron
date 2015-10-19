require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'content')

describe Thron::Gateway::Content do
  let(:klass) { Thron::Gateway::Content }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:content_id) { '32636c5f-b5d7-4800-8653-f4abff63f67b' }
  let(:category_id) { 'd8e0e4cf-4e3d-4d79-8fba-972ee6b67822' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/content"
  end

  it 'must call post to create locale' do
    route = klass.routes.fetch(:create_locale)
    locale = entity::new(name: 'italiano', locale: 'IT')
    body = { 
      client: { clientId: instance.client_id },
      contentId: content_id,
      categoryIdForAcl: category_id,
      detail: locale.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_locale(id: content_id, category_id: category_id, locale: locale)
  end

  it 'must call post to create pretty id' do
    route = klass.routes.fetch(:create_pretty_id)
    pretty_id = entity::new(id: '678', locale: 'IT')
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      categoryIdForAcl: category_id,
      prettyId: pretty_id.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_pretty_id(id: content_id, category_id: category_id, pretty_id: pretty_id)
  end

  it 'must call post to link a content' do
    route = klass.routes.fetch(:link_content)
    content =  entity::new(xcontent_id: '52425', link_type: 'hyper', selected_channel: 'AUDIO', position: 2)
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      categoryIdForAcl: category_id,
      linkedContent: content.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.link_content(id: content_id, category_id: category_id, content: content)
  end

  it 'must call post to link contents' do
    route = klass.routes.fetch(:link_contents)
    contents = 3.times.map { |i| entity::new(xcontent_id: "7847#{i}", link_type: 'plain', selected_channel: 'VIDEO', position: i) }
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      categoryIdForAcl: category_id,
      linkedContents: {
        contents: contents.map(&:to_payload)
      }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.link_contents(id: content_id, category_id: category_id, contents: contents)
  end

  it 'must call post to add player' do
    route = klass.routes.fetch(:add_player)
    embed_code = entity::new(id: '7363', name: 'SWF Flash player', use_template_id: 'object', embed_target: 'head', enabled: false, values: [ { name: 'extension', value: 'swf', locale: 'EN' } ])
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      embedCode: embed_code.to_payload
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_player(id: content_id, embed_code: embed_code)
  end

  it 'must call get to fetch category detail' do
    route = klass.routes.fetch(:detail)
    options = entity::new(return_linked_contents: true, return_linked_categories: true, return_thumb_url: false, return_itags: true, return_imetadata: false)
    query = {
      clientId: instance.client_id,
      contentId: content_id,
      locale: 'de',
      pkey: token_id
    }.merge(options.to_payload)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.detail(id: content_id, options: options, locale: 'de', access_key: token_id)
  end

  it 'must call post to find contents by properties' do
    route = klass.routes.fetch(:find)
    criteria = entity::new(content_ids: %w[id1 id2], xpublisher_id: 'publisher', locale: 'en', text_search: { search_key: 'blue suede shoes', search_key_option: 'fulltext', search_on_fields: %w[name imetadata] }, content_yype: %w[AUDIO VIDEO], from_date: Date::today-10, to_date: Date::today, only_published_in_weebo: true, metadatas: [{ name: 'reviewed_by', value: 'Rolling Stone', locale: 'de' }], ugc: false)
    options = entity::new(return_linked_contents: true, return_embed_codes: true, return_thumbnail_url: true, return_imetadata: true)
    body = { 
      client: {
        clientId: instance.client_id
      },
      criteria: criteria.to_payload,
      contentFieldOption: options.to_payload,
      locale: 'EN',
      divArea: '100x125',
      orderBy: 'name',
      offset: 4,
      numberOfresults: 12
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find(criteria: criteria, options: options, locale: 'EN', div_area: '100x125', order_by: 'name', offset: 4, limit: 12)
  end
end
