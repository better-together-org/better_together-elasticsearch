# Better Together Elasticsearch

Optional Elasticsearch integration for Community Engine.

This gem owns all Elasticsearch-specific behavior:

- Elasticsearch client configuration
- Community Engine model integration
- indexing callbacks and background jobs
- Elasticsearch search adapter wiring

`better_together` core stays Elasticsearch-free. It only exposes the generic search backend registry and searchable-model registry used by all backends.

## Community Engine models

The gem auto-registers document concerns for the built-in Better Together models during boot.

## Host app extension pattern

Host apps should define their own Elasticsearch document concern and register it with the gem.

```ruby
# config/initializers/better_together_elasticsearch.rb
BetterTogether::Elasticsearch.register_model_document(
  model_name: 'MyApp::Article',
  concern_name: 'MyApp::ArticleElasticsearchDocument'
)
```

```ruby
# app/models/concerns/my_app/article_elasticsearch_document.rb
module MyApp
  module ArticleElasticsearchDocument
    extend ActiveSupport::Concern
    include BetterTogether::Elasticsearch::Document

    included do
      settings index: default_elasticsearch_index
    end

    def as_indexed_json(_options = {})
      {
        id:,
        title:,
        body:
      }.compact.as_json
    end
  end
end
```

The concern is included into the host model during `to_prepare`, so it can safely live in the app and reload in development.

## Testing

This repo is standalone, but it boots against a local `better_together` checkout for the
host models, factories, and Rails test environment.

By default it expects the Community Engine checkout at:

```bash
../community-engine-rails
```

Override that path when needed:

```bash
BETTER_TOGETHER_PATH=/path/to/community-engine-rails
```

Run the extension specs from this repo:

```bash
bundle exec rspec spec
```

Run the Elasticsearch-backed integration slice with the backend enabled:

```bash
SEARCH_BACKEND=elasticsearch ENABLE_ELASTICSEARCH_TESTS=true \
  bundle exec rspec spec/services/better_together/search/elasticsearch_backend_search_matching_spec.rb
```
