# Load application configuration
# see: http://kpumuk.info/ruby-on-rails/flexible-application-configuration-in-ruby-on-rails/
require 'ostruct'
require 'yaml'

config = YAML.load_file("#{Rails.root}/config/config.yml") || {}
app_config = config['common'] || {}
app_config.update(config[Rails.env] || {})
AppConfig = OpenStruct.new(app_config)
