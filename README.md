jrnl
====

Getting Start
-------------

ready,

    $ bundle --path vendor/bundles install
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate

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

Generate ER document (requires Graphviz).

    $ brew install graphviz
    $ bundle exec rake erd
    $ open ERD.pdf

Testing
-------

Create test database.

    $ RAILS_ENV=test bundle exec rake db:create
    $ RAILS_ENV=test bundle exec rake db:migrate

Running tests.

    $ bundle exec rake spec

View coverage report.

    $ open coverage/index.html
