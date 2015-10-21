require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'gateway', 'publish_in_weebo_express')

describe Thron::Gateway::PublishInWeeboExpress do
  let(:klass) { Thron::Gateway::PublishInWeeboExpress }
  let(:entity) { Thron::Entity::Base }
  let(:token_id) { 'e74c924f-8f40-40f7-b18a-f9011c81972c' }
  let(:instance) { klass::new(token_id: token_id) }
  let(:response) { OpenStruct::new(code: 200) }

  it 'must set the package' do
    klass::PACKAGE.to_s.must_equal "xadmin/resources/publishinweeboexpress"
  end
end
