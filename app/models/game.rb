class Game < ActiveRecord::Base
  NUMBER_OF_PINS = 10
  NUMBER_OF_FRAMES = 10

  serialize :frames, Array

  before_save do
    self.score = frames.flatten.sum
  end

  def throw! knocked_pins:
    raise(GameError, "This game is over") if game_over?
    frames << [] if frame_completed?(frames.last)
    raise(GameError, "Knocked pins can't be more then available pins") unless knocked_pins.between?(0, avaliable_pins)
    frames.last << knocked_pins
    fill_older_open_frames_with knocked_pins
    save!
  end

  def game_over?
    frames.size==NUMBER_OF_FRAMES && frame_completed?(frames.last)
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
    return true if frame.nil? || frame.size==2 || strike?(frame)  ### =>
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
    frame[0] == NUMBER_OF_PINS
  end

  def spare? frame
    [frame[0],frame[1]].compact.sum == NUMBER_OF_PINS
  end

  def ending_frame? frame
    frames.size==NUMBER_OF_FRAMES && frames.last.equal?(frame)
  end

  def avaliable_pins
    current_frame = frames.last
    current_frame_score = current_frame.to_a.sum
    if ending_frame?(current_frame)
      return (NUMBER_OF_PINS*2 - current_frame_score) if strike?(current_frame) || spare?(current_frame)
    end
    NUMBER_OF_PINS - current_frame_score
  end
end

class GameError < StandardError
end
