require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.new }

  context "model from db" do
    it "should have initial score and frames" do
      expect(Game.new.score).to eq 0
      expect(Game.new.frames).to eq []
    end

    it "should have NUMBER_OF_PINS and NUMBER_OF_FRAMES" do
      expect(Game::NUMBER_OF_PINS).to eq 10
      expect(Game::NUMBER_OF_FRAMES).to eq 10
    end

    it "should reload same data from DB" do
      current_game = Game.create
      expect(current_game.score).to eq 0
      expect(current_game.frames).to eq []

      game1 = Game.find(current_game.id)
      game1.throw! knocked_pins: 4
      expect(game1.score).to eq 4

      game2 = Game.find(current_game.id)
      game2.throw! knocked_pins: 3
      expect(game2.score).to eq 7
      expect(game2.frames).to eq [[4,3]]
    end
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

      game.throw! knocked_pins: 4
      expect(game.score).to eq 11
      game.throw! knocked_pins: 3
      expect(game.score).to eq 14
      expect(game.frames).to eq [[4,3], [4,3]]
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
      expect(game.frames).to eq [[5,3]]*10
      expect(game.game_over?).to eq true
      expect { game.throw! knocked_pins: 3 }.to raise_error(GameError)
    end

    it "should handle strike in last frame" do
      game.throw! knocked_pins: 10
      expect(game.score).to eq 82
      expect(game.game_over?).to eq false

      expect { game.throw! knocked_pins: 3 }.not_to raise_error
      expect(game.score).to eq 85
      expect(game.game_over?).to eq false

      expect { game.throw! knocked_pins: 4 }.not_to raise_error
      expect(game.score).to eq 89
      expect(game.game_over?).to eq true
      expect(game.frames).to eq([[5,3]]*9 << [10,3,4])
      expect { game.throw! knocked_pins: 4 }.to raise_error(GameError)
    end

    it "should handle spare in last frame" do
      game.throw! knocked_pins: 4
      game.throw! knocked_pins: 6
      expect(game.score).to eq 82
      expect(game.game_over?).to eq false

      expect { game.throw! knocked_pins: 3 }.not_to raise_error
      expect(game.score).to eq 85
      expect(game.game_over?).to eq true
      expect(game.frames).to eq([[5,3]]*9 << [4,6,3])
      expect { game.throw! knocked_pins: 4 }.to raise_error(GameError)
    end
  end

  context "different test cases" do
    specify "2 strikes in a row" do
      game.throw! knocked_pins: 5
      game.throw! knocked_pins: 3
      expect(game.score).to eq 8

      game.throw! knocked_pins: 10
      expect(game.score).to eq 18

      game.throw! knocked_pins: 10
      expect(game.score).to eq 38

      game.throw! knocked_pins: 3
      expect(game.score).to eq 47
      game.throw! knocked_pins: 4
      expect(game.score).to eq 55
    end

    specify "with strikes and spares in a row" do
      game.throw! knocked_pins: 5
      game.throw! knocked_pins: 3
      expect(game.score).to eq 8

      game.throw! knocked_pins: 10
      expect(game.score).to eq 18

      game.throw! knocked_pins: 2
      expect(game.score).to eq 22
      game.throw! knocked_pins: 8
      expect(game.score).to eq 38

      game.throw! knocked_pins: 1
      expect(game.score).to eq 40
      game.throw! knocked_pins: 9
      expect(game.score).to eq 49

      game.throw! knocked_pins: 3
      expect(game.score).to eq 55
      game.throw! knocked_pins: 4
      expect(game.score).to eq 59
    end

    specify "with strike at last 2 frames" do
      (10-2).times do
        game.throw! knocked_pins: 5
        game.throw! knocked_pins: 3
      end
      expect(game.score).to eq 64

      game.throw! knocked_pins: 10
      expect(game.score).to eq 74
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 10
      expect(game.score).to eq 94
      game.throw! knocked_pins: 5
      expect(game.score).to eq 104
      game.throw! knocked_pins: 3
      expect(game.score).to eq 107
      expect(game.game_over?).to eq true
    end

    specify "with spare at last frame" do
      (10-1).times do
        game.throw! knocked_pins: 5
        game.throw! knocked_pins: 3
      end
      expect(game.score).to eq 72

      game.throw! knocked_pins: 4
      game.throw! knocked_pins: 6
      expect(game.score).to eq 82
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 7
      expect(game.score).to eq 89
      expect(game.game_over?).to eq true
    end

    specify "custome - youtube" do
      # simulating: 'https://www.youtube.com/watch?v=aBe71sD8o8c'
      game.throw! knocked_pins: 8
      game.throw! knocked_pins: 2
      expect(game.score).to eq 10
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 7
      game.throw! knocked_pins: 3
      expect(game.score).to eq 27
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 3
      game.throw! knocked_pins: 4
      expect(game.score).to eq 37
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 10
      expect(game.score).to eq 47
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 2
      game.throw! knocked_pins: 8
      expect(game.score).to eq 67
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 10
      expect(game.score).to eq 87
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 10
      expect(game.score).to eq 107
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 8
      game.throw! knocked_pins: 0
      expect(game.score).to eq 131
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 10
      expect(game.score).to eq 141
      expect(game.game_over?).to eq false

      game.throw! knocked_pins: 8
      game.throw! knocked_pins: 2
      expect(game.score).to eq 161
      game.throw! knocked_pins: 9
      expect(game.score).to eq 170
      expect(game.game_over?).to eq true
    end
  end

end
