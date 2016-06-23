class Game::Frame
  TOTAL_PINS = 10
  attr_reader :score

  def initialize last_round: false
    @score = 0
    @up_pins_count = TOTAL_PINS
    @throws_count = 0
    @expected_extra_throws_count = 0
  end

  def throw! knocked_pins:
    raise "can't throw anymore" if over?
    raise "can't knock down more pins than are still standing" if knocked_pins > @up_pins_count

    @up_pins_count -= knocked_pins
    @score += knocked_pins
    @throws_count += 1

    check_spare_or_strike if over?
  end

  def update_extra_score added_points:
    return false if @expected_extra_throws_count == 0
    @score += added_points
    @expected_extra_throws_count -= 1
    true
  end

  def over?
    @up_pins_count == 0 || @throws_count == 2
  end

private

  def check_spare_or_strike
    @expected_extra_throws_count = 2 if @throws_count == 1 && @up_pins_count == 0 #strike  (added also `@up_pins_count == 0` for readability only)
    @expected_extra_throws_count = 1 if @throws_count == 2 && @up_pins_count == 0 #spare
  end
end
