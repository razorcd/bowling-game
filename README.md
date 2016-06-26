#Bowling Game Score Board API

Rules: https://en.wikipedia.org/wiki/Ten-pin_bowling

##Development

  - `bundle` to install dependencies
  - `rspec` to run tests

##TODO

- [x] investigate 2 strikes on last grame
- [x] handle required `params`
- [X] update status code to be more expressive
- [X] replace `.to_i` in controller because `"s".to_i == 0` in ruby. (Now `update_params` checks for non digits)
- [X] lock DB row while updating so API is thread safe / multiprocess safe
- [x] move GamesController#index and cleanup view
- [ ] add API docs
- [ ] add license
