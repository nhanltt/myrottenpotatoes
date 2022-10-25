# controller for actions related to movie
class MoviesController < ApplicationController
    
    def index
        @movies = Movie.all.sort_by {|movie| movie.title} 
        # threshold = (params[:threshold]).to_i
        # @movies = Movie.with_good_reviews(threshold) if threshold 
        # @movies = @movies.for_kids if params[:for_kids]
        # @movies = @movies.recently_reviewed if params[:recently_reviewed]
        @movies = Movie.with_good_reviews(params[:threshold])
        %w(for_kids with_many_fans recently_reviewed).each do |filter|
            @movies = @movies.send(filter) if params[filter]
        end
    end

    def show 
        id = params[:id]
        @movie = Movie.find(id)
    rescue ActiveRecord::RecordNotFound
        flash[:notice] = "Not found this movie"
        redirect_to :action => 'index'
    end

    def create
        @movie = Movie.new(params[:movie])
        if @movie.save
          flash[:notice] = "#{@movie.title} was successfully created."
          redirect_to movies_path
        else
          render 'new' # note, 'new' template can access @movie's field values!
        end
      end
      
    def update
        @movie = Movie.find params[:id]
        if @movie.update(params[:movie])
            flash[:notice] = "#{@movie.title} was successfully updated."
            redirect_to movie_path(@movie)
        else
            render 'edit' # note, 'edit' template can access @movie's field values!
        end
    end
    
    # as a reminder, here is the original 'new' method:
    def new
        @movie = Movie.new
    end

    def edit
        @movie = Movie.find(params[:id])
    end

    def destroy
        @movie = Movie.find(params[:id])
        movie.destroy
        flash[:notice] = "Movie '#{@movie.title}' deleted."
        redirect_to movies_path
    end

    def search_tmdb
        begin
        search_terms = params[:search_terms]
        @movies = Movie.find_in_tmdb(search_terms)
        rescue
            flash[:warning] = "'#{search_terms}' was not found in TMDb."
        end  
    end
    
    private
    def movie_params
        params.require(:movie).permit(:threshold, :title, :rating, :description, :release_date)
    end

    # def session_params
    #     params.require(:session).permit(:threshold, :threshold, :for_kids, :with_many_fans, :recently_reviewed)
    # end
end