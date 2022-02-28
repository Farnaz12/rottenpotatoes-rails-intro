class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def index
  # @sort =params[:sort]
  # @movies = Movie.all.order(@sort)
  # end
  def index 
    @all_ratings = Movie.all_ratings 
    @rated_movies = params[:ratings] || {} 
    ratings_priority = @rated_movies
    session[:ratings]= @rated_movies #for part 3
    if @rated_movies == {}
      ratings_priority = Hash[@all_ratings.map {|x| [x, 1]}] 
    end
  
    
    @movies = Movie.with_ratings(ratings_priority .keys)
    @_header = params[:_header] || "" 
    session[:_header] = @_header #for part 3
    #sorting titles
    if @_header == "title_header"
      @movies = @movies.order(:title)
    end
    if @_header == "release_date_header"
      @movies = @movies.order(:release_date)
    end
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
