class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
    @new_game = Game.new
  end

  def create
    safe_params = params.require(:game).permit(:num_players, :num_rounds)
    
    # Create new game
    @new_game = Game.create(safe_params.merge(creator: current_user))
    if @new_game.persisted?
      @new_game.add_player(current_user)
      return redirect_to(auth_root_path, flash: {success: 'New game created successfully.'})
    else
      flash.now[:error] = 'Error creating new game.'
      return render :new
    end
  end

end
