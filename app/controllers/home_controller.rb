class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :instructions]

  def index
  end
  
  def play
    unless current_user.games.active.count == 0
      redirect_to(game_path(current_user.games.active.first))
    end
  end

  def leaders
  end

  def archives
  end

  def instructions
  end

end
