# Simple-MM

Simple-MM (Simple MatchMaking) is a rails application built for fun just to be able to explore the problems surrounding game matchmaking.

Initially the only plan was to enable a single-game (in this case CS:GO) matchmaking queue using websockets 
to queue players with eachother based on close pairing of matchmaking rating.
This has since been expanded to multiple-games, and multiple leagues within those games to be able to set 
up competitive environments with your friends to play against eachother.

If you wish to know more about the ideas I have for the application, see `thoughts` in the root directory, 
it contains spur-of-the-moment thoughts about what could be developed as part
of the problem space.

# Project setup

This project is a `ruby 3.1.2`, `rails 7.0.0+` project.

## ASDF/baremetal setup

*Although not necessary*, other than for access from local machine, and local running,
dependencies for the project are installed via [asdf-vm](https://asdf-vm.com/), follow the instructions for asdf and ensure it is installed.

Thereafter you'll need 3 plugins,

* [asdf-postgres](https://github.com/smashedtoatoms/asdf-postgres)
* [asdf-ruby](https://github.com/asdf-vm/asdf-ruby)
* [asdf-nodejs](https://github.com/asdf-vm/asdf-nodejs)

all of which can be installed via `asdf plugin add <plugin-name>` as each is found on the [shortname list](https://github.com/asdf-vm/asdf-plugins) for asdf.

After these plugins are installed, run `asdf install` and each dependency should be built at the project level.
From there,

`bundle install`

and a test run of `bin/rails s` will start the local environment, though it will most likely error due to no database being set up (unless you've already taken care of this).

One can then use the provided database and redis containers to start the required additional services and detail the connection to them in `api/.env`.

## Containerized setup

All of the application is containerized by dockerfiles found under `./docker`. 

There is currently no production build of the software.

To set up the `docker-compose` cluster, simply copy the `api/.env.example` to `api/.env` and provide all empty secrets.
The entire setup of the web server, api and database can then be started by the root directory `bin/start` script (which is just a `docker-compose up` abstraction).

To this extent, the scripts found in `bin/` are mostly docker-based, and help by providing a few commands that I found myself using when developing on the
docker setup.

## Root directory bin/ scripts

*Note: A lot of these scripts require the `tmux` commandline utility installed.*

- console:

    Starts an irb connection to the rails console on the `api/` rails docker container (as if running `bin/rails c` locally).

- db

    Starts an interactive postgresql session connected to the database (as if running `bin/rails db` locally).

- db:reset

    Drops the database and recreates it from the `api/db/structure.sql` (as if running `bin/rails db:reset` locally).

- migrate

    Performs any missing migrations on the `api` docker container (as if running `bin/rails db:migrate` locally).

- purge 

    Kills and destroys all docker containers & volumes related to the project, especially useful for resetting _everything_.

- seed

    Seeds the database with seed data (as if running `bin/rails db:seed` locally).

- start \<option\>

    The main container orchestration command, used to optionally start a variety of services required by the application.
    These options are:
    - `db` / `d`

        Starts a new `tmux` session (`simple-mm-db`) and the database container image @ `localhost:5432` (see docker-compose `db` service).
    - `rails` / `r`

        starts a new `tmux` session (`simple-mm-api`) and a rails-served development application server. Additionally starts the `db` and `redis` services to provide the storage layers for the app.
    - `test` / `t`

        starts a new `tmux` session (`simple-mm-test`) and the `db` and `redis` services in 'test' mode.
    - `spec $arg` / `s $arg`

        starts an interactive shell into the default server container image running the `bundle exec rspec` command. Additionally will create a `tmux` session (`simple-mm-test`) and start the `db` and `redis` services in 'test' mode if the session does not already exist.

        Providing an additonal argument (`$arg`) is possible, in an effort to allow individual spec running, but doing so will need to assume that the relative path starts from within `/api`, ie: `./spec/models/game_spec.rb` would be akin to the full path from this README's parent directory: `./api/spec/models/game_spec.rb`.
    - `prod` / `p`

        Currently does nothing, but should most likely do something similar to no-option invocation.
    - `web` / `w`

        starts a new `tmux` session (`simple-mm-web`) and the `node-js` front-end server to serve the contents of the `./web` directory `vuejs` front-end.
    - `sidekiq` / `sq`

        starts a new `tmux` session (`simple-mm-sidekiq`) and the `sidekiq` queue-processing server to handle jobs/workers.
    - `redis` / `rd`

        starts a new `tmux` session (`simple-mm-redis`) and the `redis` service.
- stop

    Kills all docker containers running for this project.

### Running tests

To run all specs see: 

`bin/start spec`

and the section above concerning `bin/start` scripts.

OR 

run the script suite on local baremetal

`cd ./api && bin/rspec`
