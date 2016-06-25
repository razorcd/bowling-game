#Bowling Game Score Board API

Rules: https://en.wikipedia.org/wiki/Ten-pin_bowling

##Development

  - `bundle` to install dependencies
  - `rspec` to run tests

##TODO

- [x] investigate 2 strikes on last grame
- [x] handle required `params`
- [ ] update status code to be more expressive
- [ ] replace `.to_i` in controller because `"s".to_i == 0` in ruby
- [ ] lock DB row while updating so API is thread safe / multiprocess safe
- [ ] move GamesController#index and cleanup view
