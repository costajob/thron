require 'test_helper'
require 'thron/pageable'

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
  let(:instance) { klass::new }

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

  it 'must accepts preload and limit options' do
    paginator = instance.users_paginator(preload: 10, limit: 30)
    paginator.instance_variable_get(:@preload).must_equal 10
    paginator.limit.must_equal 30
  end
end
