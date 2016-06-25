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

  def fill_older_open_frames_with value
    frames.map do |frame|
      next if frame.equal?(frames.last)
      frame << value if strike?(frame) && frame.size <= 2 #strike
      frame << value if spare?(frame) && frame.size == 2 #spare
    end
  end

  def frame_completed? frame
    return ending_frame_completed?(frame) if ending_frame?(frame)
    return true if frame.nil? || frame.size==2 || frame[0]==10
    false
  end

  def ending_frame_completed? frame
    if (strike?(frame) || spare?(frame))
      frame.size==3
    else
      frame.size==2
    end
  end

  def strike? frame
    frame[0] == 10
  end

  def spare? frame
    [frame[0],frame[1]].compact.sum == 10
  end

  def ending_frame? frame
    frames.size==10 && frames.last.equal?(frame)
  end
end

class GameError < StandardError
end
