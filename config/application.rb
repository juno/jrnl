require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Jrnl
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.assets.enabled = true

    # アセットのプリコンパイル時にデータベースアクセスやモデルのロードを行わない
    # Herokuへのデプロイ時に必要となる設定
    config.assets.initialize_on_precompile = false

    config.assets.version = '1.0'

    config.autoload_paths += %W(#{config.root}/lib)

    config.encoding = 'utf-8'

    # ログなどに表示しないパラメーター名を指定
    # 正規表現によってマッチが行われるので`*_confirmation`のような名前の指定は不要
    config.filter_parameters += [:password]

    config.generators do |generate|
      generate.assets     false
      generate.helper     false
      generate.view_specs false
    end

    config.i18n.default_locale = :ja

    config.time_zone = 'Tokyo'
  end
end
