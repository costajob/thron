require 'test_helper'
require 'thron/gateway/dashboard'

describe Thron::Gateway::Dashboard do
  let(:klass) { Thron::Gateway::Dashboard }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/dashboard"
  end

  it 'must call post to change contents owner' do
    route = klass.routes.fetch(:change_contents_owner)
    contents = entity::new(new_user_id: '666', xcontent_ids: Array::new(4) { |i| "XCONTENT_#{i}"}).to_payload
    body = { 
      clientId: instance.client_id, 
      contents: contents
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.change_contents_owner(contents: contents)
  end

  it 'must call get to download source file' do
    route = klass.routes.fetch(:download_source_file)
    filename = 'Necronomicon.pdf'
    query = { 
      clientId: instance.client_id, 
      tokenId: token_id,
      xcontentId: '666',
      saveAs: filename
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.download_source_file(content_id: '666', save_as: filename)
  end

  it 'must call post to migrate user stuff at once' do
    route = klass.routes.fetch(:migrate_user_stuff)
    user_id1, user_id2 = 'USER_01', 'USER_02'
    body = { 
      clientId: instance.client_id, 
      userId1: user_id1,
      userId2: user_id2,
      removeUserId1: true
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.migrate_user_stuff(user_id1: user_id1, user_id2: user_id2, remove_user_id1: true)
  end

  it 'must call post to propagate ACLs to sub categories' do
    route = klass.routes.fetch(:propagate_acl_to_sub_categories)
    rules = Array::new(3) { |i| { source_obj_id: i, source_obj_class: "CLASS_#{i}", rules_inverse: [], custom_metadata: [ { name: 'pretty_id', value: "PRETTY_#{i}" } ] } }
    acls = entity::new(rules: rules).to_payload
    body = { 
      clientId: instance.client_id, 
      categoryId: '666',
      acls: acls,
      force: true
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.propagate_acl_to_sub_categories(category_id: '666', acls: acls, force: true)
  end

  it 'must call post to replace source files' do
    route = klass.routes.fetch(:replace_source_files)
    file_ids = Array::new(3) { |i| "FILE_#{i}" }
    body = { 
      clientId: instance.client_id, 
      mediaContentId: '666',
      xcontentId: '667',
      sourceFiles: { repositoryFileIds: file_ids },
      removeOriginalFiles: false
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.replace_source_files(media_content_id: '666', content_id: '667', file_ids: file_ids)
  end

  it 'must call post to reset content user preferences' do
    route = klass.routes.fetch(:reset_content_user_preferences)
    body = { 
      clientId: instance.client_id, 
      xcontentId: '667'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.reset_content_user_preferences(content_id: '667')
  end

  it 'must call post to trash contents' do
    route = klass.routes.fetch(:trash_contents)
    contents = Array::new(3) { |i| entity::new(xcontent_id: "XCONTENT_#{i}", remove_options: { remove_ratings: true, remove_linked_contents: false, remove_comments: true, remove_cue_points: false, remove_custom_metadata: true }) }
    body = { 
      clientId: instance.client_id, 
      contentList: { contentsToTrash: contents.map(&:payload) }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.trash_contents(contents: contents) 
  end

  it 'must call post to untrash contents' do
    route = klass.routes.fetch(:untrash_contents)
    content_ids = Array::new(3) { |i| "XCONTENT_#{i}" }
    body = { 
      clientId: instance.client_id, 
      contentList: { 
        newUserId: '666',
        xcontentIds: content_ids
      }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.untrash_contents(new_user_id: '666', content_ids: content_ids) 
  end
end
