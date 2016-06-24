class Game < ActiveRecord::Base
  serialize :frames, Array

  before_save do
    self.score = frames.flatten.sum
  end

  def throw! knocked_pins:
    frames << [] if frame_completed?(frames.last)
    frames.last << knocked_pins
    save!
  end

private

  def frame_completed? frame
    return true if (frame.nil? || frame.size==2 || frame[0]==10)
    false
  end
end
