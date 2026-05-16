# frozen_string_literal: true

better_together_path = ENV.fetch(
  'BETTER_TOGETHER_PATH',
  File.expand_path('../../community-engine-rails', __dir__)
)

ENV['SEARCH_BACKEND'] ||= 'elasticsearch'
ENV['ENABLE_ELASTICSEARCH_TESTS'] ||= 'true'
$LOAD_PATH.unshift(File.expand_path('spec', better_together_path))
require File.expand_path('spec/rails_helper', better_together_path)
require 'better_together/elasticsearch'
