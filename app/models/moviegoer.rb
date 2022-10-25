class Moviegoer < ActiveRecord::Base
    has_many :reviews
    has_many :movies, :through => :reviews
    
    def self.create_with_omniauth(auth)
        Moviegoer.create!(
        :provider => auth["provider"],
        :uid => auth["uid"],
        :name => auth["info"]["name"])
    end
    
    def session_params
        params.require(:session).permit(:uid, :provider, :name)
    end
end
