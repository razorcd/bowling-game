
class Game
  TOTOAL_FRAMES_COUNT = 10

  def initialize
    @frames = [Game::Frame.new]
  end

  def throw! knocked_pins:
    raise "The game is over, no more throws allowed." if game_over?
    @frames.last.throw! knocked_pins: knocked_pins
    update_old_frames_with knocked_pins
    start_new_frame if @frames.last.over? && reached_frame_limit?.!
  end

  def score  #memoize for realtime compatibility
    @frames.map(&:score).inject(&:+)
  end

  def game_over?
    reached_frame_limit? && @frames.last.over?
  end

private

  def update_old_frames_with added_points
    old_frames = @frames.slice(0, (@frames.length-1)).to_a
    old_frames.each do |old_frame|
      old_frame.update_extra_score added_points: added_points
    end
  end

  def start_new_frame
    @frames << Game::Frame.new
  end

  def reached_frame_limit?
    @frames.count == TOTOAL_FRAMES_COUNT
  end

end
