OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret 
    provider :facebook, Rails.application.secrets.facebook_api_key, Rails.application.secrets.facebook_api_secret 
end

OmniAuth.config.on_failure = Proc.new {|env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

class SafeFailureEndpoint < OmniAuth::FailureEndpoint
    def call 
        redirect_to auth_failure_path
    end
end