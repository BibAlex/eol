Eol::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_store = :dalli_store
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 1

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  require "ruby-debug"
end
$STAGING_CONTENT_SERVER = 'http://localhost/eol_php_code/applications/content_server/'
Recaptcha.configure do |config|
  config.public_key  = '6LdCLOcSAAAAAEM8Tm-B8XB63WzHNIT8xaMbMfjZ'
  config.private_key = '6LdCLOcSAAAAAIVPnagKsMmh83V9TgYHPXmE0ic9'
#  config.proxy = 'http://youstina.atef:pass@proxy:8002'
end

# TODO - Where do these go, now?  :S
$UNSUBSCRIBE_NOTIFICATIONS_KEY = 'f0de2a0651aa88a090e5679e5e3a7d28'
$SERVER_PORT = '8081'
# variables used for syncing
PEER_SITE_ID = 2
AUTH_CODE = '437b8710-9250-11e3-a9d6-000ffe473aab'
REGISTRY_URL = 'http://localhost:3000/'
REGISTRY_PUSH_URL = 'push_requests/make_push'
REGISTRY_PUSH_QUERY_URL = 'push_requests/query'
REGISTRY_PULL_URL = 'pull_requests/pull'
REGISTRY_PULL_REPORT = 'pull_requests/report'
INIT_UUID = '66d6bcae-93b1-11e3-9841-000ffe473aab'
SITE_URI = 'http://127.0.0.1:3002'

Eol::Application.configure do
  config.after_initialize do
    $SOLR_SERVER = 'http://localhost:8984/solr/'
  end
end