Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  #ActionMailer
  config.action_mailer.delivery_method = :smtp
  # for Gmail
  config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :password             => ENV["GMAIL_PASSWORD"],
  :password             => ENV["GMAIL_USERNAME"],
  :authentication       => "plain"
  #:enable_starttls_auto => true
  }
end