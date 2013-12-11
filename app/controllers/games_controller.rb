class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.games.active.count == 0
      redirect_to(game_path(current_user.games.active.first))
    end
    @leaders = User.all.reject{|user| user.wins == 0}.sort_by{|user| -user.wins}
  end

  def new
    @game = Game.new
  end

  def create
    # Create new game
    safe_params = params.require(:game).permit(:num_players, :num_rounds, :timeout)
    @game = Game.create(safe_params.merge(creator: current_user))
    unless @game.errors.any?
      @game.add_player(current_user)
      return redirect_to(auth_root_path, flash: {success: 'New game created successfully.'})
    else
      flash.now[:error] = @game.errors.full_messages.to_sentence
      return render :new
    end
  end

  # Join a game
  def join
    # Confirm game exists
    return redirect_to(games_path, {flash: {error: 'Unknown game.'}}) unless @game = Game.find_by(id: params[:game_id])
    # Attempt to add player to game
    @game.add_player(current_user)
    return @game.errors.any? ? redirect_to(games_path, {flash: {error: @game.errors.full_messages.to_sentence}}) : redirect_to(game_path(@game))
  end

  # Show a game
  def show
    # Confirm game exists
    return redirect_to(games_path, {flash: {error: 'Unknown game.'}}) unless @game = Game.find_by(id: params[:id])
    # Confirm user is playing game or game is complete
    return redirect_to(games_path, {flash: {error: 'You are not playing that game.'}}) unless @game.players.include?(current_user) || @game.complete?
    @round = @game.round
  end

  # Respond action
  def respond
    # Confirm game exists
    return redirect_to(games_path, {flash: {error: 'Unknown game.'}}) unless @game = Game.find_by(id: params[:game_id])
    # Confirm game is in progress and round is accepting responses
    return redirect_to(game_path(@game), {flash: {error: 'Game is not in progress'}}) unless @game.in_progress?
    @round = @game.round
    return redirect_to(game_path(@game), {flash: {error: 'Round is not accepting responses'}}) unless @round.accepting_responses?
    # Save response
    safe_params = params.require(:response).permit(:response)
    response = @round.save_response(safe_params.merge(player: current_user))
    # Render/Redirect
    if response.errors.any?
      flash.now[:error] = response.errors.full_messages.to_sentence
      return render :show
    else
      return redirect_to(game_path(@game))
    end
  end

  # Score action
  def score
    # Confirm game exists
    return redirect_to(games_path, {flash: {error: 'Unknown game.'}}) unless @game = Game.find_by(id: params[:game_id])
    # Confirm game is in progress, round is accepting scores, and current_user is the judge for round
    return redirect_to(game_path(@game), {flash: {error: 'Game is not in progress'}}) unless @game.in_progress?
    @round = @game.round
    return redirect_to(game_path(@game), {flash: {error: 'Round is not accepting scores'}}) unless @round.accepting_scores?
    return redirect_to(game_path(@game), {flash: {error: 'You are not the judge for this round'}}) unless @round.judge == current_user
    # Save scores
    safe_params = params.require(:round).permit(responses_attributes: [:id, :points])
    @round.save_scores(safe_params)
    # Render/Redirect
    if @round.errors.any?
      flash.now[:error] = @round.errors.full_messages.to_sentence
      return render :show
    else
      return redirect_to(game_path(@game))
    end
  end

end
