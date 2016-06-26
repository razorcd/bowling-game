require 'rails_helper'

RSpec.describe "Games", type: :request do
  before(:each) { Rails.cache.clear }

  describe "POST /api/games" do
    it "should create a game" do
      post api_games_path
      expect(response).to have_http_status(201)
      expect(JSON.parse response.body).to eq({"id" => 1})
    end
  end

  describe "GET /api/games/:id" do
    let(:game) { Game.create }

    it "should show the score" do
      expect(Game).to receive(:find_by).and_call_original
      get api_game_path(game.id.to_s)
      expect(response).to have_http_status(200)
      expect(JSON.parse response.body).to eq({"score" => 0, "frame_number" => 1, "game_over" => false})
    end

    it "should cache the response" do
      expect(Game).to receive(:find_by_id).and_call_original
      get api_game_path(game.id.to_s) #creates cache

      expect(Game).not_to receive(:find_by_id).and_call_original
      get api_game_path(game.id.to_s)
      expect(response).to have_http_status(200)
      expect(JSON.parse response.body).to eq({"score" => 0, "frame_number" => 1, "game_over" => false})
    end
  end

  describe "PUT /api/games/:id" do
    it "should update score" do
      new_game = Game.create
      put api_game_path(new_game.id.to_s, "knocked_pins" => "5")
      expect(response).to have_http_status(204)
      expect(Game.find(new_game.id).score).to eq 5
      expect(Game.find(new_game.id).frames).to eq [[5]]
    end

    it "should return error message when knocking too many pins" do
      new_game = Game.create
      put api_game_path(new_game.id.to_s, "knocked_pins" => "11")
      expect(response).to have_http_status(422)
      expect(JSON.parse response.body).to eq({"message"=> "Can't knock more pins than available."})
    end


    it "should return error message when throwing after game is over" do
      new_game = Game.create
      10.times do
        put api_game_path(new_game.id.to_s, "knocked_pins" => "4")
        put api_game_path(new_game.id.to_s, "knocked_pins" => "4")
      end
      expect(Game.find(new_game.id).frames).to eq([[4,4]]*10)

      put api_game_path(new_game.id.to_s, "knocked_pins" => "4")
      expect(response).to have_http_status(422)
      expect(JSON.parse response.body).to eq({"message"=> "This game is over."})
    end

    context " on missing required params" do
      it "should raise error when required param is missing" do
        new_game = Game.create
        expect { put api_game_path(new_game.id.to_s) }.to raise_error ActionController::ParameterMissing
      end

      it "should raise error when required param is blank" do
        new_game = Game.create
        expect { put api_game_path(new_game.id.to_s, "knocked_pins" => "") }.to raise_error ActionController::ParameterMissing
      end

      it "should raise error when required param is not a number" do
        new_game = Game.create
        expect { put api_game_path(new_game.id.to_s, "knocked_pins" => "4de5") }.to raise_error ActionController::ParameterMissing
      end
    end
  end
end
