class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Retrieve ratings from movies table
    @all_ratings = Movie.ratings

    # COLUMN SORTING LOGIC
    if params[:sort]!=nil
      # Use user-specificd sort filter
      @sort= params[:sort].to_s
      # Update session state
      session[:sort]= @sort
    elsif session[:sort]!=nil
      # Restore session state
      @sort= session[:sort]
    else
      @sort= nil
    end
    
    # RATING FILTER LOGIC
    if params[:ratings]!=nil
      # Use user-specified rating filters
      @ratings = params[:ratings]
      # Update state
      session[:ratings] = @ratings
    elsif session[:ratings]!=nil
      # Restore rating filters from if there exists a previous session
      @ratings = session[:ratings]
    else # First Load of page... show all ratings
      # Create a hash to simulate ratings[] value retrieved from checkboxes
      ratings_hash = {}
      @all_ratings.each {|rating| ratings_hash[rating]="1"}
      # Set to instance var
      @ratings = ratings_hash
      # Update state
      session[:ratings] = @ratings
    end
    
    # LOAD FILTERED/SORTED MOVIE RECORDS
    if ['title', 'release_date'].include?(@sort)
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.keys}, :order => @sort)
    else
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.keys})
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