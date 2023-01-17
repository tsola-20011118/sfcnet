class TaxiController < ApplicationController

    def taxi
        
    end

    def wait
        if @user != nil
            #taxi==trueにして待機状態に変更する
            @user.taxi = true;
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
            @waiting_user = User.where(taxi: true).limit(5);
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
        if !User.find_by(id: params[:id]) || User.find_by(id: params[:id]).taxi == false
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
        if !User.find_by(id: params[:id]) || User.find_by(id: params[:id]).taxi == false
            flash[:error] = "存在しないページです";
            redirect_to "/home/top" and return;
        end
        #誘ったことがない時の誘う処理
        if Taxiconnect.find_by(to:params[:id], from:session[:id]) == nil
            #ログインユーザー->該当ユーザーのTaxiconnectの作成
            Taxiconnect.new(to:params[:id], from:session[:id]).save;
            #相手からも誘われていた時->/user/talkに移行（チャット画面）
            if Taxiconnect.find_by(to:params[:id], from:session[:id]) && Taxiconnect.find_by(from:params[:id], to:session[:id])
                redirect_to "/user/talk/#{params[:id]}" and return;
            else #相手から誘われていない時->承認待ちの状態で/home/topに移行
                flash[:error] = "承認待ちです"
                redirect_to "/taxi/waiting" and return;
            end
        else #誘ったことがある時/home/topに移行
            flash[:error] = "既に誘っています"
            redirect_to "/taxi/waiting" and return;
        end

    end

    def exit
        #ログインユーザーがいるとき
        if @user != nil
            #taxiをfalseにして諦めた処理
            @user.taxi = false;
            @user.save;
            #Taxiconnectの全てを削除
            Taxiconnect.where(from:@user.id).or(Taxiconnect.where(to:@user.id)).each{|temp|
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
        @connectUser = Taxiconnect.where(to: @user.id).order(created_at: :desc).limit(5);
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
        if !Taxiconnect.find_by(to: @user.id, from:@touser.id)
            flash[:error] = "不正なアクセスです"
            redirect_to "/home/top" and return;
        end
        Taxiconnect.new(to: @touser.id, from:@user.id).save;
        redirect_to "/user/talk/#{@touser.id}"
    end

end


