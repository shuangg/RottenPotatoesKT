class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort].to_s
    
    # Retrieve checked ratings
    if params[:ratings]!=nil
      @checked_ratings = params[:ratings].keys
      @checked_ratings_hash = params[:ratings]
    else
      @checked_ratings = @all_ratings
    end

    if ['title', 'release_date'].include?(@sort)
      @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings}, :order => @sort)
    else
      @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end