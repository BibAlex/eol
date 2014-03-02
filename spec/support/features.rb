Dir[Rails.root.join("spec/support/features/*.rb")].each {|f| require f}
RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::ApiHelpers, type: :feature
end
