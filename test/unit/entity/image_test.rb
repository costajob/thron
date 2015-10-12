require 'test_helper'
require Thron.root.join('lib', 'thron', 'entity', 'image')

describe Thron::Entity::Image do
  let(:klass) { Thron::Entity::Image }

  describe 'valid path' do
    let(:file) { Tempfile::new('avatar.txt') << 'Avatar image of the user profile' }
    let(:instance) { klass::new(path: file.path) }
    before { file.rewind }

    it 'must initialize state' do
      %i[path buffer mime_type].each do |attr|
        instance.instance_variable_defined?(:"@#{attr}")
      end
    end

    it 'must valorize the mime_type' do
      instance.mime_type.must_equal 'text/plain'
    end

    it 'must valorize the buffer' do
      instance.buffer.wont_be_empty
    end
  end

  it 'must take the arguments if path is not existent' do
    mime_type = 'application/json'
    buffer = [86,112,-74] 
    instance = klass::new(mime_type: mime_type, buffer: buffer)
    instance.mime_type.must_equal mime_type
    instance.buffer.must_equal buffer
  end
end
