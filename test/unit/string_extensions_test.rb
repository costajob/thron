require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'string_extensions')

using Thron::StringExtensions

describe Thron::StringExtensions do
  it 'must snakecase words' do
    "SnakeCaseThis".snakecase.must_equal "snake_case_this"
  end

  it 'must low camelize words' do
    "camelize_this_word".camelize_low.must_equal "camelizeThisWord"
  end
end
