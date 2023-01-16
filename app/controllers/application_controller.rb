class ApplicationController < ActionController::Base
    before_action :sessioninto;

    def sessioninto
        @user = User.find_by(id: session[:id]);
    end

end
