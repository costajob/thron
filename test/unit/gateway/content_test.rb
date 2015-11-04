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

  %w[create update].each do |action|
    it "must call post to #{action} content locale" do
      route = klass.routes.fetch(:"#{action}_content_locale")
      locale = entity::new(name: 'italiano', locale: 'IT')
      body = { 
        client: { clientId: instance.client_id },
        contentId: content_id,
        detail: locale.to_payload,
        categoryIdForAcl: category_id
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(:"#{action}_content_locale", id: content_id, locale: locale, category_id: category_id)
    end

    it "must call post to #{action} content pretty id" do
      route = klass.routes.fetch(:"#{action}_content_pretty_id")
      pretty_id = entity::new(id: '678', locale: 'IT')
      body = { 
        clientId: instance.client_id,
        contentId: content_id,
        prettyId: pretty_id.to_payload,
        categoryIdForAcl: category_id
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(:"#{action}_content_pretty_id", id: content_id, pretty_id: pretty_id, category_id: category_id)
    end

    it 'must call post to #{action} content player' do
      route = klass.routes.fetch(:"#{action}_content_player")
      data = entity::new(id: '7363', name: 'SWF Flash player', use_template_id: 'object', embed_target: 'head', enabled: false, values: [ { name: 'extension', value: 'swf', locale: 'EN' } ])
      body = { 
        clientId: instance.client_id,
        contentId: content_id,
        embedCode: data.to_payload
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(:"#{action}_content_player", id: content_id, data: data)
    end
  end

  it 'must call post to link a content' do
    route = klass.routes.fetch(:link_content)
    data = entity::new(xcontent_id: '52425', link_type: 'hyper', selected_channel: 'AUDIO', position: 2)
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      linkedContent: data.to_payload,
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.link_content(id: content_id, data: data, category_id: category_id)
  end

  it 'must call post to link contents' do
    route = klass.routes.fetch(:link_contents)
    contents = 3.times.map { |i| entity::new(xcontent_id: "7847#{i}", link_type: 'plain', selected_channel: 'VIDEO', position: i) }
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      linkedContents: {
        contents: contents.map(&:to_payload)
      },
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.link_contents(id: content_id, contents: contents, category_id: category_id)
  end

  it 'must call get to fetch content detail' do
    route = klass.routes.fetch(:content_detail)
    options = entity::new(return_linked_contents: true, return_linked_categories: true, return_thumb_url: false, return_itags: true, return_imetadata: false)
    query = {
      clientId: instance.client_id,
      contentId: content_id,
      locale: 'de',
      pkey: token_id
    }.merge(options.to_payload)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.content_detail(id: content_id, options: options, locale: 'de', access_key: token_id)
  end

  it 'must call post to find contents by properties' do
    route = klass.routes.fetch(:find_contents)
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
      offset: 0,
      numberOfresults: 50
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    paginator = instance.find_contents(criteria: criteria, options: options, locale: 'EN', div_area: '100x125', order_by: 'name')
    paginator.next
  end

  it 'must call post to move linked contents' do
    route = klass.routes.fetch(:move_linked_content)
    body = { 
      clientId: instance.client_id,
      xcontentId: content_id,
      oldPosition: 1,
      newPosition: 4,
      linkType: 'symbolic'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.move_linked_content(id: content_id, from: "1", to: 4.0, link_type: 'symbolic')
  end

  it 'must call post to remove locale' do
    route = klass.routes.fetch(:remove_content_locale)
    query = {
      clientId: instance.client_id,
      contentId: content_id,
      locale: 'de',
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_content_locale(id: content_id, locale: 'de')
  end

  it 'must call post to remove pretty id' do
    route = klass.routes.fetch(:remove_content_pretty_id)
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      locale: 'IT',
      categoryIdForAcl: category_id 
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_content_pretty_id(id: content_id, locale: 'IT', category_id: category_id)
  end

  it 'must call post to unlink contents' do
    route = klass.routes.fetch(:unlink_contents)
    ids = 3.times.map { |i| "7847#{i}" }
    criteria = entity::new(linked_contents_id: ids, link_type: 'plain')
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      criteria: criteria.to_payload,
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.unlink_contents(id: content_id, criteria: criteria, category_id: category_id)
  end

  it 'must call post to remove content player' do
    route = klass.routes.fetch(:remove_content_player)
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      embedCodeId: 7363
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.remove_content_player(id: content_id, player_id: 7363)
  end

  it 'must call post to update content solutions' do
    route = klass.routes.fetch(:update_content_solutions)
    solutions = %w[solution1 solution2 solution3] 
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      contentValues: {
        availableInSolutions: solutions
      },
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_content_solutions(id: content_id, solutions: solutions, category_id: category_id)
  end

  it 'must call post to update content' do
    route = klass.routes.fetch(:update_content)
    data = entity::new(status: 'OPEN', creation_date: Date::today-10, owner: 'elvis', inactive_date: Date::today-7, sorting_field: 'name', patch: [{ op: 'DESC', field: 'name' }])
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      contentValues: data.to_payload,
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_content(id: content_id, data: data, category_id: category_id)
  end

  it 'must call post to update players' do
    route = klass.routes.fetch(:update_content_players)
    players = 3.times.map { |i| entity::new(id: "7363#{i}", name: 'SWF Flash player', use_template_id: 'object', embed_target: 'head', enabled: false, values: [ { name: 'extension', value: 'swf', locale: 'EN' } ]) }
    body = { 
      clientId: instance.client_id,
      contentId: content_id,
      embedCodes: {
        embedCodes: players.map(&:to_payload)
      },
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_content_players(id: content_id, players: players, category_id: category_id)
  end

  it 'must call post to update user data' do
    route = klass.routes.fetch(:update_content_access_data)
    username = 'elvis'
    data = entity::new(content_read_value: 'bane', content_starred: true)
    body = { 
      clientId: instance.client_id,
      username: username,
      contentId: content_id,
      contentParams: data.to_payload,
      categoryIdForAcl: category_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_content_access_data(id: content_id, username: username, data: data, category_id: category_id)
  end
end
