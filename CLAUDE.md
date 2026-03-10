# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

個人ブログアプリケーション。Ruby on Rails 8.1, Ruby 4.0.1, PostgreSQL。

## Common Commands

```bash
# セットアップ
bundle install
# DB設定は既存の config/database.yml / 環境変数を使用
bin/rails db:setup

# 開発サーバー
bin/dev

# テスト（全実行）
bin/rake

# テスト（単一ファイル）
bundle exec rspec spec/models/post_spec.rb

# Lint
bundle exec rubocop

# オートロード検証
bin/rails zeitwerk:check

# アセットビルド
bin/rake assets:precompile
```

## Architecture

標準的なRails MVC構成。モデルは Post と User の2つのみ。

- **Post**: `content` カラムにMarkdownを保存し、Redcarpetで HTML に変換。`title` は本文先頭から70文字を切り出し
- **User**: Devise認証。投稿の作成/編集/削除にログインが必要
- **ルーティング**: `GET /` → 記事一覧、`GET /:id` → 記事詳細（パーマリンク）、`GET /archives/:year/:month` → 月別アーカイブ、`GET /admin` → 管理画面（認証必須）
- **設定**: `config/x/jrnl.yml` にアプリ固有設定（キャッシュ、author情報、SNSリンク、Feedburner等）
- **フロントエンド**: Sprockets + jQuery + SCSS（開発はSprocketsのみで完結するが、本番用アセットプリコンパイルには JavaScript ランタイム（一般的には Node.js）が必要）
- **デプロイ**: VPS

## Testing

RSpec + FactoryBot + Capybara + Shoulda::Matchers。SimpleCovでカバレッジ計測。

- ファクトリ定義: `spec/factories.rb`
- Feature spec（Capybara）: `spec/features/`
- Deviseヘルパーは controller spec で自動 include

## Code Style (RuboCop)

- ダブルクォートを使用（`Style/StringLiterals: double_quotes`）
- 行長制限なし
- メソッド長は最大20行
- `frozen_string_literal` コメント不要
- プラグイン: rubocop-performance, rubocop-rails, rubocop-rspec, rubocop-rubycw

## CI

GitHub Actions で push to main / PR 時に実行:
1. PostgreSQL起動 → `db:schema:load` → `zeitwerk:check` → `bin/rake` → `assets:precompile`
2. PR時は reviewdog + RuboCop でPRチェックにアノテーションを追加
