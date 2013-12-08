class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.games.active.count == 0
      redirect_to(game_path(current_user.games.active.first))
    end
  end

  def new
    @game = Game.new
  end

  def create
    safe_params = params.require(:game).permit(:num_players, :num_rounds)
    
    # Create new game
    @game = Game.create(safe_params.merge(creator: current_user))
    if @game.persisted?
      @game.add_player(current_user)
      return redirect_to(auth_root_path, flash: {success: 'New game created successfully.'})
    else
      flash.now[:error] = 'Error creating new game.'
      return render :new
    end
  end

  # Join a game
  def join
    # Confirm game exists
    unless @game = Game.find_by(id: params[:game_id])
      return redirect_to(games_path, {flash: {error: 'Unknown game.'}})
    end
    # Confirm user isn't already playing a game
    unless current_user.games.active.count == 0
      return redirect_to(games_path, {flash: {error: 'Please finish your current game first.'}})
    end
    # Attempt to add player to game
    if @game.add_player(current_user)
      return redirect_to(game_path(@game))
    else
      redirect_to(games_path, {flash: {error: 'Unknown error joining game.'}})
    end
  end

  # Show a game
  def show
    # Confirm game exists
    return redirect_to(games_path, {flash: {error: 'Unknown game.'}}) unless @game = Game.find_by(id: params[:id])
    # Show game if completed
    return render(:show_complete) if @game.complete?
    # Confirm user is playing game
    return redirect_to(games_path, {flash: {error: 'You are not playing that game.'}}) unless @game.players.include?(current_user)
    # Render waiting view
    return render(:show_waiting) if @game.waiting?
    # Render in progress view
    return render(:show_in_progress) if @game.in_progress?
  end

  # Respond action
  def respond
    safe_params = params.require(:response).permit(:response)
    # Confirm game exists
    return redirect_to(games_path, {flash: {error: 'Unknown game.'}}) unless @game = Game.find_by(id: params[:game_id])
    # Confirm game is in progress (so current_round doesn't fail)
    return redirect_to(game_path(@game), {flash: {error: 'Game is not accepting responses'}}) unless @game.in_progress?
    # Create response
    response = @game.current_round.responses.create(safe_params.merge(player: current_user))
    flash[:error] = response.errors.full_messages.to_sentence if response.errors.any?
    return redirect_to(game_path(@game))
  end

end
