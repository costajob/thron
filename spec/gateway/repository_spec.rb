require 'spec_helper'
require 'thron/gateway/repository'

describe Thron::Gateway::Repository do
  let(:klass) { Thron::Gateway::Repository }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }
  let(:resource) { entity::new(bucket: 'elvis_songs/bucket', file_path: 'songs.pslist', rename_file_to: 'elivs_songs.csv').to_payload }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xpackager/resources/repository"
  end

  it 'must call post to add files to the platform' do
    route = klass.routes.fetch(:add_files)
    files = Array::new(5) { |i| entity::new(id: i, file_name: "FILENAME_#{i}", path: "path/to/file_#{i}", total_space: 1024**i, mimetype: 'document/pdf', available_on_sites: [ { site_name: "SITE_NAME_#{i}", status: "STATUS_#{i}", last_update: "2015-0#{i+1}-15" } ], removed: false, user_id: "USER_#{i}") }.map(&:to_payload)
    body = {
      clientId: instance.client_id,
      files: { files: files }
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_files(files: files)
  end

  it 'must call post to add S3 resource to the platform' do
    route = klass.routes.fetch(:add_s3_resource)
    body = {
      clientId: instance.client_id,
      resource: resource,
      remove_resource_if_possible: false
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_s3_resource(resource: resource)
  end

  it 'must call post to add Web resource to the platform' do
    route = klass.routes.fetch(:add_web_resource)
    body = {
      clientId: instance.client_id,
      webResource: resource
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.add_web_resource(resource: resource)
  end

  %i[delete_ftp_file delete_uploaded_file].each do |message|
    it "must call post to #{message.to_s.split('_').join(' ')} from the platform" do
      route = klass.routes.fetch(message)
      file = entity::new(id: '666', file_name: 'FILENAME', path: 'path/to/file', total_space: 1024**2, mimetype: 'document/pdf', available_on_sites: [ { site_name: 'www.elvis.com', status: 'WORKING', last_update: '2015-11-15' } ], removed: false, user_id: '667').to_payload
      body = {
        clientId: instance.client_id,
        file: file
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, file: file)
    end
  end

  %i[get_ftp_file_list get_uploaded_file_list].each do |message|
    it "must call post to #{message.to_s.split('_').join(' ')}" do
      route = klass.routes.fetch(message)
      criteria = entity::new(ids: %w[ID1 ID2 ID3], file_name: 'elvis', mimetype: 'document/pdf', with_removed_files: false, purged: false).to_payload
      body = {
        clientId: instance.client_id,
        criteria: criteria,
        orderByField: 'fileName_D',
        offset: 0,
        numberOfResult: 0
      }.to_json
      mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message, criteria: criteria, order_by: 'fileName_D')
    end
  end

  %i[get_quota_usage get_s3_credentials].each do |message|
    it "must call post to #{message.to_s.split('_').join(' ')}" do
      route = klass.routes.fetch(message)
      query = {
        clientId: instance.client_id,
      }
      mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: true) }) { response }
      instance.send(message)
    end
  end
end
