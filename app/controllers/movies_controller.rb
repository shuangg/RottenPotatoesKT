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
    if params[:sort]==nil
      @sort= session[:sort] # Restore session
    else
      @sort= params[:sort]
      session[:sort]= @sort # Update session
    end

    # RATING FILTER LOGIC (set @ratings to correct hash)
    if params[:commit]=='Refresh'
      if params[:ratings]!=nil
        @ratings = params[:ratings] # Should be a hash
      else
        # It's nil... must create empty hash
        @ratings = {}
      end
      session[:ratings] = @ratings # Update session
    else
      if session[:ratings]==nil
        @ratings= {}
      else
        @ratings=session[:ratings] # Restore session
      end
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