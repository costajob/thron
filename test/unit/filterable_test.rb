require 'test_helper'
require Thron::root.join('lib', 'thron', 'filterable')

module Mock
  class Klass
    include Thron::Filterable

    %i[check_credentials validate_role].each do |message|
      define_method(message) do |*args|
        []
      end
    end

    def call_me
      :called
    end

    before :check_credentials, :validate_role do |instance|
      instance.call_me
    end
  end
end

describe Thron::Filterable do
  let(:klass) { Mock::Klass }
  let(:instance) { klass::new }

  %i[check_credentials validate_role].each do |message|
    it "must call specified filter before #{message} method" do
      mock(instance).call_me
      instance.send(message)
    end
  end
end
