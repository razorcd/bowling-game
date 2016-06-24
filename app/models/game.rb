class Game < ActiveRecord::Base
  serialize :frames, Array

  before_save do
    self.score = frames.flatten.sum
  end

  def throw! knocked_pins:
    raise(GameError, "This game is over") if game_over?
    frames << [] if frame_completed?(frames.last)
    frames.last << knocked_pins
    fill_older_open_frames_with knocked_pins
    save!
  end

  def game_over?
    frames.size==10 && frame_completed?(frames.last)
  end

private

  def frame_completed? frame
    return true if (frame.nil? || frame.size==2 || frame[0]==10)
    false
  end

  def fill_older_open_frames_with value
    frames.map do |frame|
      next if frame == frames.last
      frame << value if frame[0]==10 && frame.size <= 2 #strike
      frame << value if (frame[0]+frame[1])==10 && frame.size == 2 #spare
    end

  end
end

class GameError < StandardError
end
