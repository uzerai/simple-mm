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

This project is a `ruby 3.0.3`, `rails 7.0.0+` project.

To get up and running quickly, the project uses [asdf-vm](https://asdf-vm.com/) to handle dependencies, and [docker](https://www.docker.com/) (and subsequently `docker-compose`)
to ensure ease of setup across devices.

## ASDF/on-local setup

*Although not necessary*, other than for access from local machine, and local running,
dependencies for the project are installed via [asdf-vm](https://asdf-vm.com/), follow the instructions for asdf and ensure it is installed.

Thereafter you'll need 3 plugins,

* [asdf-postgres](https://github.com/smashedtoatoms/asdf-postgres)
* [asdf-ruby](https://github.com/asdf-vm/asdf-ruby)
* [asdf-nodejs](https://github.com/asdf-vm/asdf-nodejs)

all of which can be installed via `asdf plugin add <plugin-name>` as each is found on the [shortname list](https://github.com/asdf-vm/asdf-plugins) for asdf.

## Docker-compose setup

All of the application is containerized by dockerfiles found under `./docker`. 

There is currently no production build of the software.

To set up the `docker-compose` cluster, simply copy the `api/.env.example` to `api/.env` and provide all empty secrets.
The entire setup of the web server, api and database can then be started by the root directory `bin/start` script (which is just a `docker-compose up` abstraction).

To this extent, the scripts found in `bin/` are mostly docker-based, and help by providing a few commands that I found myself using when developing on the
docker setup.

## Root directory bin/ scripts
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

- start <<container_name>>

    Starts a single container (if specified) or starts all docker containers for this project (if not specified).

- stop

    Kills all docker containers running for this project.

### Running tests

* There are no tests, lol
