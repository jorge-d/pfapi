class GamesController < ApplicationController
  before_filter :get_game, only: [:show]
  
  def get_game
    @game = Game.find(params[:id])
    if !@game
      return false
    end
    return true
  end
  
  def show
    @scores = @game.scores.order("value DESC")
  end
  
  def index
    @games = Game.all
    
    # render json: @games
  end
end