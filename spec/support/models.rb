Dir[Rails.root.join("spec/support/models/*.rb")].each {|f| require f}
RSpec.configure do |config|
  config.include Models::CacheHelpers, type: :model
end
