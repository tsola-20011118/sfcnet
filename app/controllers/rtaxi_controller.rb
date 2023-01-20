class RtaxiController < ApplicationController
     def taxi
        
    end

    
    def wait
        if @user != nil
            #taxi==trueにして待機状態に変更する
            @user.rtaxi = true;
            @user.save;
        else #ログインユーザーがいない時の処理
            flash[:error] = "ログインしてください"
            redirect_to "/user/login" and return;
        end
        redirect_to("/home/top");
    end

    def waiting
        if @user != nil
            #taxi == trueの人を直近５人@waitinguserに入れる
            @waiting_user = User.where(rtaxi: true).limit(5);
        else #ログインユーザーがいない時の処理
            flash[:error] = "ログインしてください"
            redirect_to("/user/login");
        end
    end

    def connect
        #ログインユーザーがいない時の処理
        if session[:id] == nil
            flash[:error] = "ログインしてください";
            redirect_to "/user/login" and return;
        end
        #不正アクセスの場合
        if !User.find_by(id: params[:id]) || User.find_by(id: params[:id]).rtaxi == false
            flash[:error] = "存在しないページです";
            redirect_to "/home/top" and return;
        end
        @touser = User.find_by(id: params[:id]);
    end

    def match
        #ログインユーザーがいない時の処理
        if session[:id] == nil
            flash[:error] = "ログインしてください";
            redirect_to "/user/login" and return;
        end
        #不正アクセスの場合
        if !User.find_by(id: params[:id]) || User.find_by(id: params[:id]).rtaxi == false
            flash[:error] = "存在しないページです";
            redirect_to "/home/top" and return;
        end
        #誘ったことがない時の誘う処理
        if Rtaxiconnect.find_by(to:params[:id], from:session[:id]) == nil
            #ログインユーザー->該当ユーザーのRtaxiconnectの作成
            Rtaxiconnect.new(to:params[:id], from:session[:id]).save;
            #相手からも誘われていた時->/user/talkに移行（チャット画面）
            if Rtaxiconnect.find_by(to:params[:id], from:session[:id]) && Rtaxiconnect.find_by(from:params[:id], to:session[:id])
                redirect_to "/user/talk/#{params[:id]}" and return;
            else #相手から誘われていない時->承認待ちの状態で/home/topに移行
                flash[:error] = "承認待ちです"
                redirect_to "/rtaxi/waiting" and return;
            end
        else #誘ったことがある時/home/topに移行
            flash[:error] = "既に誘っています"
            redirect_to "/rtaxi/waiting" and return;
        end

    end

    def exit
        #ログインユーザーがいるとき
        if @user != nil
            #taxiをfalseにして諦めた処理
            @user.rtaxi = false;
            @user.save;
            #Rtaxiconnectの全てを削除
            Rtaxiconnect.where(from:@user.id).or(Rtaxiconnect.where(to:@user.id)).each{|temp|
                temp.destroy
            }
        else
            flash[:error] = "ログインしてください"
            redirect_to "/user/login" and return;
        end
        redirect_to "/home/top" and return;
    end

    def check
        if !@user
            flash[:error] = "ログインしてください"
            redirect_to "/user/login" and return;
        end
        @usersid = [];
        @connectUser = Rtaxiconnect.where(to: @user.id).order(created_at: :desc).limit(5);
        for index in @connectUser
            @usersid.push(index.from);
        end
    end

    def checkD
        #ログインユーザーがいない時の処理
        if !@user
            flash[:error] = "ログインしてください"
            redirect_to "/user/login" and return;
        end
        @touser = User.find_by(id: params[:id]);
        #不正アクセス処理
        if !@touser
            flash[:error] = "存在しないページです"
            redirect_to "/home/top" and return;
        end
        if !Rtaxiconnect.find_by(to: @user.id, from:@touser.id)
            flash[:error] = "不正なアクセスです"
            redirect_to "/home/top" and return;
        end
        Rtaxiconnect.new(to: @touser.id, from:@user.id).save;
        redirect_to "/user/talk/#{@touser.id}"
    end
end
