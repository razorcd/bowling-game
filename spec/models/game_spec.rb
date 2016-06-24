require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.new }

  it "should have score and frames" do
    expect(Game.new.score).to eq 0
    expect(Game.new.frames).to eq []
  end

  context "one frame" do
    it "should show correct score" do
      game.throw! knocked_pins: 4
      expect(game.score).to eq 4
      game.throw! knocked_pins: 3
      expect(game.score).to eq 7
      expect(game.frames).to eq [[4,3]]
    end
  end

  context "multiple games" do
    it "should show correct score" do
      game.throw! knocked_pins: 4
      game.throw! knocked_pins: 3

      game.throw! knocked_pins: 5
      expect(game.score).to eq 12
      game.throw! knocked_pins: 2
      expect(game.score).to eq 14
      expect(game.frames).to eq [[4,3], [5,2]]
    end

    context "with a strike" do
      it "should have correct score" do
        game.throw! knocked_pins: 10
        expect(game.score).to eq 10

        game.throw! knocked_pins: 5
        game.throw! knocked_pins: 3
        expect(game.score).to eq 26
        expect(game.frames).to eq [[10, 5, 3], [5,3]]
      end
    end

    context "with a spare" do
      it "should have correct score" do
        game.throw! knocked_pins: 4
        game.throw! knocked_pins: 6
        expect(game.score).to eq 10

        game.throw! knocked_pins: 5
        game.throw! knocked_pins: 3
        expect(game.score).to eq 23
        expect(game.frames).to eq [[4, 6, 5], [5,3]]
      end
    end
  end

  context "all frames" do
    before :each do
      (10-1).times do
        game.throw! knocked_pins: 5
        game.throw! knocked_pins: 3
      end
    end

    it "should not allow more throws" do
      game.throw! knocked_pins: 5
      game.throw! knocked_pins: 3
      expect(game.score).to eq 80
      expect(game.frames).to eq [[5,3],[5,3],[5,3],[5,3],[5,3],[5,3],[5,3],[5,3],[5,3],[5,3]]
      expect(game.game_over?).to eq true
      expect { game.throw! knocked_pins: 3 }.to raise_error(GameError)
    end


  end
end
