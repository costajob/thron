require 'test_helper'
require Thron.root.join('lib', 'thron', 'inflector')
entities = Dir[Thron.root.join('lib', 'thron', 'entity', '*.rb')]
entities.each { |f| require f }

using Thron::Inflector

entities.map { |f| File.basename(f, '.rb').camelize }.each do |name|
  describe Thron::Entity::const_get(name) do
    let(:klass) { Thron::Entity::const_get(name) }

    it 'must inherit mappable class methods' do
      %i[factory default].each do |message|
        klass.must_respond_to message
      end
    end

    it 'must inherit mappable instance methods' do
      %i[to_payload].each do |message|
        klass.instance_methods.must_include message
      end
    end
  end
end



