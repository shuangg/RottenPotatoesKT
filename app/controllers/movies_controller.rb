class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    no_params = params[:sort]==nil and params[:ratings]==nil
    has_session = session[:sort]!=nil or session[:ratings]!=nil

    if no_params and has_session
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    else
      # Retrieve ratings from movies table
      @all_ratings = Movie.ratings

      # Update Sort Param and rating filter params
      @sort= params[:sort]
      params[:ratings]==nil ? @ratings={} : @ratings = params[:ratings]
      
      # Update stored session data
      session[:sort]= @sort # Update session
      session[:ratings] = @ratings # Update session
    
      # LOAD FILTERED/SORTED MOVIE RECORDS
      if ['title', 'release_date'].include?(@sort)
        @movies = Movie.find(:all, :conditions => {:rating => @ratings.keys}, :order => @sort)
      else
        @movies = Movie.find(:all, :conditions => {:rating => @ratings.keys})
      end
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