require 'spec_helper'
require 'thron/gateway/publishing_process'

describe Thron::Gateway::PublishingProcess do
  let(:klass) { Thron::Gateway::PublishingProcess }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/publishingprocess"
  end

  it 'must call post to change channel status' do
    route = klass.routes.fetch(:change_channel_status)
    body = { 
      clientId: instance.client_id, 
      mediaContentId: '666',
      xcontentId: '667',
      channel: 'ch06',
      active: true
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.change_channel_status(media_content_id: '666', content_id: '667', channel: 'ch06', active: true)
  end

  it 'must call post to get content types' do
    route = klass.routes.fetch(:get_content_types)
    file_names = Array::new(4) { |i| "FILE_NAME_#{i}" }
    body = { 
      clientId: instance.client_id, 
      files: { fileNames: file_names }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.get_content_types(file_names: file_names)
  end

  it 'must call post to unpublish content' do
    route = klass.routes.fetch(:unpublish_content)
    body = { 
      clientId: instance.client_id, 
      mediaContentId: '666',
      xcontentId: '667',
      force: true,
      removeSourceFiles: false
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.unpublish_content(media_content_id: '666', content_id: '667', force: true)
  end

  it 'must call post to update pagelet content' do
    route = klass.routes.fetch(:update_pagelet_content)
    body = { 
      clientId: instance.client_id, 
      mediaContentId: '666',
      xcontentId: '667',
      body: 'blue suede shoes',
      mimeType: 'application/json'
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_pagelet_content(media_content_id: '666', content_id: '667', body: 'blue suede shoes', mime_type: 'application/json')
  end

  it 'must call post to update publishing properties' do
    route = klass.routes.fetch(:update_publishing_properties)
    properties = entity::new(enable_geo_blocking: true, only_certified_clients: false, use_authentication_web_service: true, countries: %w[US EU AU], as_black_list: false).to_payload
    body = { 
      clientId: instance.client_id, 
      mediaContentId: '666',
      xcontentId: '667',
      properties: properties
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_publishing_properties(media_content_id: '666', content_id: '667', properties: properties)
  end

  %i[publish remove].each do |action|
    it "must call post to #{action} channel" do
      route = klass.routes.fetch(:"#{action}_channel")
      body = { 
        clientId: instance.client_id, 
        mediaContentId: '666',
        xcontentId: '667',
        channel: 'ch06'
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send("#{action}_channel", media_content_id: '666', content_id: '667', channel: 'ch06')
    end
  end

  %i[create_content_for_channel new_content new_live_event_content new_pagelet_content new_playlist_content replace_thumbnail].each do |message|
    it "must call post to #{message.to_s.split('_').join(' ')}" do
      route = klass.routes.fetch(message)
      body = { 
        clientId: instance.client_id,
        param: {}
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, data: {})
    end
  end
end
