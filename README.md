jrnl
====

[![Ruby on Rails CI](https://github.com/juno/jrnl/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/juno/jrnl/actions/workflows/rubyonrails.yml)

[![CodeQL](https://github.com/juno/jrnl/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/juno/jrnl/actions/workflows/codeql-analysis.yml)

Getting Start
-------------

ready,

    $ bundle --path vendor/bundles
    $ bundle exec rails db:setup

set,

    $ cp config/application.example.yml config/application.yml
    $ vi config/application.yml

    $ bundle exec rails c
    > u = User.new
    > u.email = 'foo@example.com'
    > u.password = '*****'
    > u.password_confirmation = '*****'
    > u.save!

go!

    $ bundle exec rails s

Documentation
-------------

Generate API documents.

    $ bundle exec rake yard
    $ open doc/index.html

Testing
-------

Create test database.

    $ RAILS_ENV=test bundle exec rake db:create
    $ RAILS_ENV=test bundle exec rake db:migrate

Running tests.

    $ bundle exec rake spec

View coverage report.

    $ open coverage/index.html
