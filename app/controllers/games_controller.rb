class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.games.active.count == 0
      redirect_to(game_path(current_user.games.active.first))
    end
  end

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

  # Join a game
  def join
    # Confirm user isn't already playing a game
    unless current_user.games.active.count == 0
      return redirect_to(games_path, {flash: {error: 'Please finish your current game first.'}})
    end
    # Confirm game exists
    game = Game.find_by(id: params[:game_id])
    unless game
      return redirect_to(games_path, {flash: {error: 'Game does not exist.'}})
    end
    # Attempt to add player to game
    if game.add_player(current_user)
      return redirect_to(game_path(game))
    else
      redirect_to(games_path, {flash: {error: 'Unknown error joining game.'}})
    end
  end

  # Show a game
  def show
    @game = Game.find_by(id: params[:id])
  end

end
