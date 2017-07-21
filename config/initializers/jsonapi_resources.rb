JSONAPI.configure do |config|
  # Allowed values are :integer(default), :uuid, :string, or a proc
  config.resource_key_type = :uuid

  # optional request features
  config.allow_include = true
  config.allow_sort = true
  config.allow_filter = true

  config.raise_if_parameters_not_allowed = true

  # built in paginators are :none, :offset, :paged
  config.default_paginator = :offset

  # Output pagination links at top level
  config.top_level_links_include_pagination = true

  config.default_page_size = 25
  config.maximum_page_size = 100

  # Output record count in top level meta for find operation
  config.top_level_meta_include_record_count = false
  config.top_level_meta_record_count_key = :record_count
  config.top_level_meta_include_page_count = false
  config.top_level_meta_page_count_key = :page_count
  config.use_text_errors = false

  # built in key format options are :underscored_key, :camelized_key and :dasherized_key
  config.json_key_format = :dasherized_key
  #:underscored_route, :camelized_route, :dasherized_route, or custom
  config.route_format = :dasherized_route

  # List of classes that should not be rescued by the operations processor.
  # For example, if you use Pundit for authorization, you might
  # raise a Pundit::NotAuthorizedError at some point during operations
  # processing. If you want to use Rails' `rescue_from` macro to
  # catch this error and render a 403 status code, you should add
  # the `Pundit::NotAuthorizedError` to the `exception_class_whitelist`.
  config.exception_class_whitelist = []
  # Resource Linkage
  # Controls the serialization of resource linkage for non compound documents
  # NOTE: always_include_to_many_linkage_data is not currently implemented
  config.always_include_to_one_linkage_data = false
  config.always_include_to_many_linkage_data = false
  # The default Operation Processor to use if one is not defined specifically
  # for a Resource.
  config.default_processor_klass = JSONAPI::Processor
  # Allows transactions for creating and updating records
  # Set this to false if your backend does not support transactions (e.g. Mongodb)
  config.allow_transactions = true
  # Formatter Caching
  # Set to false to disable caching of string operations on keys and links.
  # Note that unlike the resource cache, formatter caching is always done
  # internally in-memory and per-thread; no ActiveSupport::Cache is used.
  config.cache_formatters = true
  # Relationship reflection invokes the related resource when updates
  # are made to a has_many relationship. By default relationship_reflection
  # is turned off because it imposes a small performance penalty.
  config.use_relationship_reflection = false
  # Resource cache
  # An ActiveSupport::Cache::Store or similar, used by Resources with caching enabled.
  # Set to `nil` (the default) to disable caching, or to `Rails.cache` to use the
  # Rails cache store.
  config.resource_cache = Rails.cache

  # Default resource cache field
  # On Resources with caching enabled, this field will be used to check for out-of-date
  # cache entries, unless overridden on a specific Resource. Defaults to "updated_at".
  config.default_resource_cache_field = :updated_at
  # Resource cache digest function
  # Provide a callable that returns a unique value for string inputs with
  # low chance of collision. The default is SHA256 base64.
  config.resource_cache_digest_function = Digest::SHA2.new.method(:base64digest)
  # Resource cache usage reporting
  # Optionally provide a callable which JSONAPI will call with information about cache
  # performance. Should accept three arguments: resource name, hits count, misses count.
  config.resource_cache_usage_report_function = nil

end
