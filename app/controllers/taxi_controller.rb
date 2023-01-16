class TaxiController < ApplicationController


    def taxi
        
    end

    def wait
        if @user != nil
            @user.taxi = true;
            @user.save;
        else
            flash[:error] = "ログインしてください"
        end
        redirect_to("/home/top");
    end

    def waiting
        if @user != nil
            @waiting_user = User.where(taxi: true).limit(5);
        else
            flash[:error] = "ログインしてください"
            redirect_to("/home/top");
        end
        
    end

    def connect
        @touser = User.find_by(id: params[:id]);
        # render action: :connect;
    end

    def match
        #誘ったことがない時の誘う処理
        if Taxiconnect.find_by(to:params[:id], from:session[:id]) == nil
            # #誘う＝待機状態にする
            # @user.taxi = true;
            # @user.save;
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

    def check
    
    end

    # def go
    #     @touser = User.find_by(id: params[:id]);
    #     @taxi = Taxiconnect.where(to:params[:id]);
    #     if @taxi
    #         @touser.taxi = false;
    #         @touser.save;
    #         @taxi.each {|temp|
    #             temp.destroy
    #         }
    #     end
    #     if @user.taxi == true
    #         @user.taxi = false;
    #         @user.save;
    #         @taxi = Taxiconnect.where(to:@user.id);
    #         if @taxi
    #             @taxi.each {|temp|
    #                 temp.destroy
    #             }
    #         end
    #     end
    #     if @touser.id > @user.id
    #         @first = @user.id;
    #         @second = @touser.id;
    #     else
    #         @first = @touser.id;
    #         @second = @user.id;
    #     end
    #     if Talkflag.find_by(first: @first, second:@second) == nil
            
    #     end
    #     redirect_to("/user/talk/#{@touser.id}");
    # end

    def exit
        if @user != nil
            @user.taxi = false;
            @user.save;
            Taxiconnect.where(from:@user.id).each{|temp|
                temp.destroy
            }
            Taxiconnect.where(to:@user.id).each{|temp|
                temp.destroy
            }
        else
            flash[:error] = "ログインしてください"
        end
        redirect_to("/home/top");
    end

end
