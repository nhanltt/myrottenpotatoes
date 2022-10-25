class ReviewsController < ApplicationController
    before_action :has_moviegoer_and_movie, :only => [:new, :create]
    before_action :load_movie
    def index 
        @reviews = Review.all
        @reviews = @movie.reviews.all
    end

    protected
    def has_moviegoer_and_movie
        unless @current_user
        flash[:warning] = 'You must be logged in to create a review.'
        redirect_to login_twitter_path
        end
        unless (@movie = Movie.find_by_id(params[:movie_id]))
        flash[:warning] = 'Review must be for an existing movie.'
        redirect_to movies_path
        end
    end
    
    public
    def create
        @current_user.reviews << @movie.reviews.build(params[:review])
        redirect_to movie_path(@movie)
    end

    def update
        @review = @movie.reviews.find(params[:id])
        if @review.update(params[:review])
            flash[:notice] = "Your review was successfully updated."
            redirect_to movie_reviews_path(@movie)
        else
            render 'edit'
        end
    end

    def new
        if Review.wrote_reviews(@current_user.id, @movie.id) == []
            @review = @movie.reviews.build
        else
            redirect_to movie_reviews_path(@movie)
        end
    end

    def edit
        @review = @movie.reviews.find(params[:id])
    end

    def show 
        @review = @movie.reviews.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:notice] = "The movie doen't have any review"
        redirect_to :action => 'index'
    end

    private
    def review_params
        params.require(:review).permit(:potatoes, :comments, :movie_id, :id)
    end

    def load_movie
        @movie = Movie.find(params[:movie_id])
    end
end
