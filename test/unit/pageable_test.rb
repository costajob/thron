require 'test_helper'
require Thron::root.join('lib', 'thron', 'pageable')

module Mock
  class Gateway
    include Thron::Pageable

    paginate :groups, :users

    %i[groups users].each do |message|
      define_method(message) do |*args|
        []
      end
    end
  end
end

describe Thron::Pageable do
  let(:klass) { Mock::Gateway }
  let(:instance) { Mock::Gateway::new }

  it 'must initialize class variables' do
    assert klass.instance_variable_defined?(:@paginated_apis)
  end

  it 'must define paginated methods' do
    klass::paginator_methods.each do |message|
      instance.must_respond_to(message)
    end
  end

  it 'must return a paginator instance' do
    klass::paginator_methods.each do |message|
      instance.send(message).must_be_instance_of Thron::Paginator
    end
  end

  it 'must cache paginator instances' do
    klass::paginator_methods.each do |message|
      instance.send(message)
      assert instance.instance_variable_defined?(:"@#{message}")
    end
  end

  it 'must reset paginator instances' do
    klass::paginator_methods.each do |message|
      instance.send(message)
    end
    instance.reset_paginators
    klass::paginator_methods.each do |message|
      instance.instance_variable_get(:"@#{message}").must_be_nil
    end
  end

  it 'must accepts preload and limit options' do
    paginator = instance.users_paginator(preload: 10, limit: 30)
    paginator.instance_variable_get(:@preload).must_equal 10
    paginator.limit.must_equal 30
  end
end