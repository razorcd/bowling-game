[![Build Status](https://travis-ci.org/razorcd/bowling-game.svg?branch=master)](https://travis-ci.org/razorcd/bowling-game)

#Bowling Game Score Board API

Rules: https://en.wikipedia.org/wiki/Ten-pin_bowling

Start the server and call the REST JSON API or try the rough SPA demo at `http://localhost:3000/demo`

Read the [API documentation](https://github.com/razorcd/bowling-game/blob/master/API_doc.md) for endpoints details.

##Development

  - `bundle` to install dependencies
  - `rspec` to run tests

##TODO

- [x] implement game logic using TDD (test first)
- [x] persist it's state to handle stateless requests
- [x] add integration tests
- [x] add REST Endpoints for `Game` on `create`, `show`, `update`
- [x] investigate 2 strikes on last grame
- [x] handle required `params`
- [x] update status code to be more expressive
- [x] replace `.to_i` in controller because `"s".to_i == 0` in ruby. (Now `update_params` checks for non digits)
- [x] lock DB row while updating so API is thread safe / multiprocess safe
- [x] move GamesController#index and cleanup view
- [x] add API docs
- [x] add license
- [x] add CI (with Travis)
- [ ] deploy to Heroku
- [ ] disable assets and compilation
- [ ] ensure default json content type
