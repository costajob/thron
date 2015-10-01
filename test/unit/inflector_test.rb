require 'test_helper'
require_relative Thron::root.join('lib', 'thron', 'inflector')
using Thron::Inflector

describe Thron::Inflector do
  it 'must pluralize' do
    "permission".pluralize.must_equal "permissions"
  end

  it 'must singularize' do
    "permissions".singularize.must_equal "permission"
  end

  it 'must pluralize special forms' do
    "anomaly".pluralize.must_equal "anomalies"
  end

  it 'must singularize special froms' do
    "anomalies".singularize.must_equal "anomaly"
  end

  it 'must snakecase words' do
    "SnakeCaseThis".snakecase.must_equal "snake_case_this"
  end

  it 'must camelize words' do
    "i_camelize_this".camelize.must_equal "ICamelizeThis"
  end
end
