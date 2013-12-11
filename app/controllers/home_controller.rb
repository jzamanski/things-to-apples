class HomeController < ApplicationController

  def play
    authenticate_user!
    unless current_user.games.active.count == 0
      redirect_to(game_path(current_user.games.active.first))
    end
  end

  def leaders
    authenticate_user!
  end

  def archives
    authenticate_user!
  end

  def instructions
  end

end
