require 'test_helper'
require 'thron/gateway/v_user_manager'

describe Thron::Gateway::VUserManager do
  let(:klass) { Thron::Gateway::VUserManager }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:username) { 'elvis' }
  let(:password) { 'presley' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200, body: {}) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xsso/resources/vusermanager"
  end

  it 'must call post to create a new user' do
    route = klass.routes.fetch(:create_user)
    data = Thron::Entity::Base::new(user_type: 'EXTERNAL_USER', detail: { dob: Date::new(1935,1,8), gender: 'male', contact_type: 'rocker', icalls: [{ inumber_category: 'external', inumber: '38363' }], addresses: [{ address_category: 'personal', street: '3734 Elvis Presley Blvd', pobox: '38116', local_area: 'TN', city: 'Memphis', area: '6 ha', postcode: '38116', country: 'US', primary: true }], image: { image_url: 'http://images1.mtv.com/uri/mgid:file:docroot:cmt.com:/sitewide/assets/img/artists/presley_elvis/elvispresley07-430x250.jpg?width=361&height=210&enlarge=true&matte=true&matteColor=black&quality=0.85' }, name: { prefix: 'Mr', first_name: 'Elvis', middle_name: 'Aaron', last_name: 'Presley', suffix: 'king' }, user_preferences: { time_zone_id: '1', locale: 'EN', notification_property: { email: 'elvis@gmail.com', notify_by: %w[mail po-box], auto_subscribe_to_categories: true } } }, user_quota: 1000, user_lock_template: 'king', send_first_access_notification: false).to_payload
    body = { 
      clientId: instance.client_id,
      newUser: {
        username: username,
        password: password
      }
    }.merge(data).to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.create_user(username: username, password: password, data: data)
  end

  it 'must call get to fetch user detail' do
    route = klass.routes.fetch(:user_detail)
    options = entity::new(return_itags: false, return_imetadata: true).to_payload
    query = { 
      clientId: instance.client_id,
      username: username,
      offset: 7,
      numberOfResults: 5
    }.merge(options)
    mock(klass).get(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.user_detail(username: username, options: options, offset: 7, limit: 5)
  end
  
  it 'must call post to find users by properties' do
    route = klass.routes.fetch(:find_users)
    criteria = entity::new(usernames: %w[george paul], user_types: %w[PLATFORM_USER EXTERNAL_USER], active: true, user_roles: %w[SINGER GUITAR-PLAYER], text_search: 'obladì obladà', lastname: 'George', firstname: 'Harrison', email: 'beatles@gmail.com', created_by: %w[Lennon McCartney], external_id: '6765').to_payload
    options = entity::new(return_own_acl: false, return_itags: true, return_imetadata: true).to_payload
    body = { 
      clientId: instance.client_id,
      criteria: criteria,
      orderBy: 'name',
      fieldsOption: options, 
      offset: 0,
      numberOfResult: 30
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.find_users(criteria: criteria, order_by: 'name', options: options, limit: 30)
  end

  it 'must call post to check user validity' do
    route = klass.routes.fetch(:check_credentials)
    query = { 
      clientId: instance.client_id,
      username: username,
      password: password
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.check_credentials(username: username, password: password)
  end

  it 'must call post to get a temporary token' do
    route = klass.routes.fetch(:temporary_token)
    body = { 
      clientId: instance.client_id,
      username: username
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.temporary_token(username: username)
  end

  it 'must call post to update password' do
    route = klass.routes.fetch(:update_password)
    query = { 
      clientId: instance.client_id,
      username: username,
      newpassword: password
    }
    mock(klass).post(route.url, { query: query, body: {}, headers: route.headers(token_id: token_id, dash: false) }) { response }
    instance.update_password(username: username, password: password)
  end

  it 'must call post to update status' do
    route = klass.routes.fetch(:update_status)
    data = entity::new(active: false, expiry_date: Date::today + 365).to_payload
    body = { 
      clientId: instance.client_id,
      username: username,
      properties: data
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_status(username: username, data: data)
  end

  it 'must call post to update capabilities' do
    route = klass.routes.fetch(:update_capabilities_and_roles)
    capabilities = entity::new(capabilities: %w[SINGER GUITAR-PLAYER BASS-PLAYER DRUMMER], user_roles: %w[PLATFORM-USER EXTERNAL-USER], enabled_solutions: %w[CONTRACT-BY-ALBUM PAY-BY-CONCERT]).to_payload
    body = { 
      clientId: instance.client_id,
      username: username,
      userCapabilities: capabilities
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_capabilities_and_roles(username: username, capabilities: capabilities)
  end

  it 'must call post to update external id' do
    route = klass.routes.fetch(:update_external_id).call([instance.client_id, username])
    external_id = entity::new(id: '65757', external_type: 'name').to_payload
    body = { 
      externalId: external_id
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_external_id(username: username, external_id: external_id)
  end

  it 'must call post to update image' do
    file = Tempfile::new('profile.jpg') << "This is the profile image"
    file.rewind
    image = Thron::Entity::Image::new(path: file.path).to_payload
    route = klass.routes.fetch(:update_image)
    body = { 
      clientId: instance.client_id,
      username: username,
      buffer: image
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_image(username: username, image: image)
  end

  it 'must call post to update settings' do
    route = klass.routes.fetch(:update_settings)
    settings = entity::new(user_quota: 455, user_lock_template: 'STANDARD').to_payload
    body = { 
      clientId: instance.client_id,
      username: username,
      settings: settings
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_settings(username: username, settings: settings)
  end

  it 'must call post to update user data' do
    route = klass.routes.fetch(:update_user).call([instance.client_id, username])
    data = entity::new(metadata: [{ name: 'genere', value: 'rock' }], user_preferences: { time_zone_id: '2', locale: 'EN', default_category_id: '65756' }, detail: { dob: Date::new(1943,2,25), gender: 'male', note: 'here come the sun', icalls: [{ inumber_category: 'test category', inumber: '567' } ], name: { first_name: 'George', last_name: 'Harrison' } }).to_payload
    body = { 
      update: data
    }.to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.update_user(username: username, data: data)
  end

  it 'must call post to upgrade user' do
    route = klass.routes.fetch(:upgrade_user)
    password = 'lovemetender'
    data = entity::new(user_quota: 50, new_user_detail: { gender: 'female', urls: [{ url_category: 'personal', url: 'https://en.wikipedia.org/wiki/Cher_albums_discography' }] }, new_user_params: { user_preferences: { locale: 'IT' } }).to_payload
    body = { 
      clientId: instance.client_id,
      username: username,
      newPassword: password,
    }.merge(data).to_json
    mock(klass).post(route.url, { query: {}, body: body, headers: route.headers(token_id: token_id, dash: true) }) { response }
    instance.upgrade_user(username: username, password: password, data: data)
  end
end
