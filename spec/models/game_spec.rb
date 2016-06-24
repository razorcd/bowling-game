require 'rails_helper'

RSpec.describe Game, type: :model do
  it "should have score and frames" do
    expect(Game.new.score).to eq 0
    expect(Game.new.frames).to eq [[]]
  end

  context "one frame" do
    let(:game) { Game.new }

    it "should show correct score" do
      game.throw! knocked_pins: 4
      expect(game.score).to eq 4
      game.throw! knocked_pins: 3
      expect(game.score).to eq 7

      expect(game.frames).to eq [[4,3]]
    end
  end


end