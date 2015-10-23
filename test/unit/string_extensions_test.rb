require 'test_helper'
require_relative Thron.root.join('lib', 'thron', 'string_extensions')

using Thron::StringExtensions

describe Thron::StringExtensions do
  it 'must snakecase words' do
    "SnakeCaseThis".snakecase.must_equal "snake_case_this"
    "snake_case_this".snakecase.must_equal "snake_case_this"
  end

  it 'must low camelize words' do
    "camelize_this_word".camelize_low.must_equal "camelizeThisWord"
    "camelizeThisWord".camelize_low.must_equal "camelizeThisWord"
  end

  it 'must preserve uppercase postfixes' do
    "SnakeCasePOSTFIX".snakecase.must_equal "snake_case_POSTFIX"
    "camelize_POSTFIX".camelize_low.must_equal "camelizePOSTFIX"
  end
end
