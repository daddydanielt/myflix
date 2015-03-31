Myflix::Application.configure do
  #Note: In Rails 4.0/4.1 the default test environment
  # (config/environments/test.rb) is not threadsafe. 
  # If you experience random errors about missing constants, 
  # add config.allow_concurrency = false to config/environments/test.rb.
  config.allow_concurrency = false

  config.cache_classes = true

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection    = false

  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
end
