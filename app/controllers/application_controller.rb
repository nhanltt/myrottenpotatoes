class ApplicationController < ActionController::Base
    before_action do
        resource = controller_name.singularize.to_sym
        method = "#{resource}_params"
        params[resource] &&= send(method) if respond_to?(method, true)
    end

    # login function
    before_action :set_current_user
    
    protected # prevents method from being invoked by a route
    
    def set_current_user
        # we exploit the fact that find_by_id(nil) returns nil
        @current_user ||= Moviegoer.find_by_id(session[:user_id])
        return unless @current_user
    end
end
