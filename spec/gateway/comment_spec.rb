require 'spec_helper'
require 'thron/gateway/comment'

describe Thron::Gateway::Comment do
  let(:klass) { Thron::Gateway::Comment }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xcontents/resources/comment"
  end

  it 'must call get to fetch comment detail' do
    route = klass.routes.fetch(:comment_detail)
    query = {
      clientId: instance.client_id,
      commentId: '666'
    }
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.comment_detail(comment_id: '666')
  end

  it 'must call get to fetch comments list' do
    route = klass.routes.fetch(:list_comments)
    criteria = entity::new(content_id: '666', keyword: 'blue suede', status: 'CLOSED', user_id: 'elvis', moderation_status: 'REJECTED').to_payload
    query = {
      clientId: instance.client_id,
      locale: 'EN',
      orderBy: 'description_D',
      offset: 0,
      numberOfResults: 0
    }.merge(criteria)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.list_comments(criteria: criteria, locale: 'EN', order_by: 'description_D')
  end

  it 'must call post to insert a new comment' do
    route = klass.routes.fetch(:insert_comment)
    data = entity::new(description: 'do not step on my blue suede shoes', user_id: 'elvis', status: 'OPEN', reply_to: 'priscilla', metadatas: Array::new(3) { |i| { name: "title", value: "step #{i}", locale: 'EN' } }).to_payload
    body = {
      clientId: instance.client_id,
      contentId: '666',
      comment: data,
      categoryIdForAcl: '667'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.insert_comment(content_id: '666', data: data, category_id: '667')
  end

  it 'must call post to report comment abuse' do
    route = klass.routes.fetch(:report_comment_abuse)
    query = {
      clientId: instance.client_id,
      commentId: '666',
      userId: '667'
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.report_comment_abuse(comment_id: '666', user_id: '667')
  end
end
