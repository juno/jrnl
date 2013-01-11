# -*- coding: utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

if defined?(Bundler)
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module Jrnl
  class Application < Rails::Application
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

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery.min rails jquery.embedly.min)
  end
end
