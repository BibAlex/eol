# Load the rails application
require File.expand_path('../application', __FILE__)

EolUpgrade::Application.initialize!

# The order of environment loading is:
# 1) config/environment.rb
# 2) config/environments/#{Rails.env}.rb (THIS FILE)
# 3) config/environments/#{Rails.env}_eol_org.rb
override_environment_with_values_from(File.join(File.dirname(__FILE__), 'environments', "#{Rails.env}_eol_org"))
# 4) config/environment_eol_org.rb
override_environment_with_values_from(File.join(File.dirname(__FILE__), 'environment_eol_org'))
override_environment_with_values_from(File.join(File.dirname(__FILE__), 'environments', 'local'))

# variables used for syncing
PEER_SITE_ID = 1
AUTH_CODE = 'Auth123'
REGISTRY_URL = 'http://localhost:8001/'
REGISTRY_PUSH_URL = 'tasks/push_request.php'
REGISTRY_PUSH_QUERY_URL = 'tasks/push_query.php'
INIT_UUID = 'cef6da60-3a13-11e2-a6b3-080027e646e9'
SITE_URI = 'http://10.0.2.2:3000'