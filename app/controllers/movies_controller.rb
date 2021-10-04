class MoviesController < ApplicationController

  before_action :enforce_login, except: [:index, :show]
  before_action :set_current_user

  def index
    @movies = Movie.all
    respond_to do |format|
      format.html
      format.xml {render xml: @movies.to_xml}
      format.json {render json: @movies.to_json}
    end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)

    respond_to do |format|
      format.html
      format.xml {render xml: @movie.to_xml}
      format.json {render json: @movie.to_json}
    end


  end

  def new
    @movie = Movie.new
    render 'new'
  end

  def create
    movie_params = params.require(:movie).permit(:title, :rating, :release_date)
    @movie = Movie.new movie_params
    if (@movie.save)
      flash[:notice] = "Movie #{@movie.title} was successfully created!"
      redirect_to movies_path
    else
      render 'new'
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    movie_params = params.require(:movie).permit(:title, :rating, :release_date)
    if @movie.update movie_params
      flash[:notice] = "Movie #{@movie.title} successfully updated!"
      redirect_to movies_path
    else
      render 'edit'
    end
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "Movie #{@movie.title} successfully deleted!"
    redirect_to movies_path
  end

  def enforce_login
    redirect_to login_path if not logged_in?
  end

end