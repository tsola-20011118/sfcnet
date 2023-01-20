class ApplicationController < ActionController::Base
    before_action :sessioninto;
    before_action :newTalk;

    def sessioninto
        @user = User.find_by(id: session[:id]);
    end

    def newTalk
        if @user
            if @user.talktempnum != @user.talknum
                flash[:error] = "新しいマッチングを検出しました！MESSAGEを確認しましょう！"
                @user.talktempnum = @user.talknum;
                @user.save;
            end
        end

    end

end
