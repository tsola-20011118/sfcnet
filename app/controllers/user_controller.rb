class UserController < ApplicationController

  
  def login
  end

  def logined
    if @user
      redirect_to "/user/login" and return;
    end
    #入力のない項目があったら
    # if params[:password]
    #   flash[:error] = "パスワードを入力してください"
    #   redirect_to "/user/login" and return;
    # end
    # if params[:mail]
    #   flash[:error] = "メールアドレスを入力してください"
    #   redirect_to "/user/login" and return;
    # end
    #メールから@loginuserにUser情報を格納
    @loginuser = User.find_by(mail: params[:mail]);
    #もしパスワードが正しかったら
    if @loginuser == nil
      flash[:error] = "登録されていないメールアドレスです"
      redirect_to "/user/login" and return;
    end
    #パスワードが正しい時
    if @loginuser.passward == params[:password]
      session[:id] = @loginuser.id;
      redirect_to("/user/#{session[:id]}");
    else #パスワードが間違っているとき
      flash[:error] = "パスワードが間違っています"
      redirect_to "/user/login" and return;
    end
  end

  def logout
    #ログインユーザーがない時の処理
    if session[:id] == nil
      flash[:error] = "ログインしてください"
      redirect_to("/user/login");
    else #session[:id]をnilにしてhomeに飛ぶ
      session[:id] = nil;
      redirect_to("/home/top");
    end
  end

  def new
  end

  def create
    #新規User　作成
    @user = User.new(name: params[:name], age: params[:age], mail: params[:mail], passward: params[:passward], sex: params[:sex], taxi: false);
    @user.save
    #もし登録がうまく行ったら
    if @user.save
      session[:id] = @user.id;
      redirect_to("/user/#{session[:id]}");
    end
  end

  def mypage
    @pageuser = User.find_by(id: params[:id]);
    if !@pageuser
      flash[:error] = "存在しないページです";
      redirect_to("/home/top");
    end
  end

  def edit
    #不正アクセス時
    if session[:id] == nil || User.find_by(id: params[:id]).id != @user.id
      flash[:error] = "不正なアクセスを検出しました";
      redirect_to("/home/top");
    end
  end

  def editer
    #不正アクセス時
    if session[:id] == nil || @user.id != params[:id].to_i
      flash[:error] = "不正なアクセスを検出しました";
      redirect_to "/home/top" and return;
    else
      #編集内容の更新
      @user.name = params[:name];
      @user.age = params[:age];
      @user.mail = params[:mail];
      @user.passward = params[:passward];
      @user.sex = params[:sex];
      @user.save
      if @user.save
        session[:id] = @user.id;
        @pageuser = @user;
        render action: :mypage;
      else
        #saveがうまくいかなかった時の処理
        flash[:error] = "すべての項目を入力してください";
        redirect_to "/user/#{@user.id}/edit" and return;
      end
    end
  end

  def destroy
    #不正アクセス時
    if session[:id] == nil || params[:id].to_i != @user.id
      flash[:error] = "不正なアクセスを検出しました";
    else
      session[:id] = nil;
      @user.destroy;
    end
    redirect_to("/home/top");
  end


  def talk
    if session[:id] == nil then #未ログインユーザーのアクセス処理
      flash[:error] = "ログインしてください";
      redirect_to "/user/login" and return;
    elsif @user.id == params[:id].to_i then #ログインユーザーとログインユーザーのtalkにアクセスした時
      flash[:error] = "存在しないページです";
      redirect_to "/home/top" and return;
    else
      #params[:id]のidのUserを@touserに格納
      @touser = User.find_by(id: params[:id]);
      #存在しないUserにアクセスした時
      if @touser == nil
        flash[:error] = "存在しないページです";
        redirect_to "/home/top" and return;
      end
      #User.idの小さい方をfirst,大きい方をsecondとする
      if @touser.id > @user.id
        @first = @user.id;
        @second = @touser.id;
      else
        @first = @touser.id;
        @second = @user.id;
      end
      @talkflag = Talkflag.find_by(first: @first, second:@second);
      #エラー処理
      if !Taxiconnect.find_by(to:params[:id], from:session[:id]) && !Taxiconnect.find_by(from:params[:id], to:session[:id]) && !@talkflag
        flash[:error] = "アクセスできないユーザーです";
        redirect_to "/home/top" and return;
      end
      #どちらも誘い合っている時のTaxiconnect削除（この時マッチングしている）
      if Taxiconnect.find_by(to:params[:id], from:session[:id]) && Taxiconnect.find_by(from:params[:id], to:session[:id])
        Taxiconnect.find_by(to:@user, from:@touser.id).destroy;
        Taxiconnect.find_by(to:@touser, from:@user.id).destroy;
        @user.taxi = false;
        @user.save;
        @touser.taxi = false;
        @touser.save;
        flash[:error] = "マッチングしました！待ち合わせ場所を決めましょう！"
      end
      #既にTalkflagがあるとき（これまでにマッチングしたことがある）チャット画面を表示
      if @talkflag
        @flag = @talkflag.id;
        #メッセージ一覧を最新から５個@messageに格納
        @messages = (Talk.where(flag: @flag).order(created_at: :desc).limit(5));
        #メッセージが送信されている場合に新しいTalkを作る
        if params[:message] != nil
          @new = Talk.new(to:@touser.id, from:@user.id, message:params[:message], flag: @flag)
          @new.save
        end
      else #Talkflagがない時talkflagを作る
        Talkflag.new(first: @first, second:@second).save;
      end
    end
  end

  def talkindex
    #ログインユーザーがいない時の処理
    if @user == nil
      flash[:error] = "ログインしてください"
      redirect_to("/user/login")
    else #ログインユーザーがいる時の処理
      #@users = ログインユーザーと会話している人のid一覧
      @users = [];
      #@meusers = ログインユーザーの所持するTalkflag一覧
      @meusers = Talkflag.where(first: @user.id).or(Talkflag.where(second: @user.id))
      for temp in @meusers
        #ログインユーザーでない方のidをusersに入れる
        if @user.id != temp.first.to_i
          @users.push(temp.first);
        end
        if @user.id != temp.second.to_i
          @users.push(temp.second);
        end
      end
      #@usersの重複削除
      @users.uniq;
    end
  end
end
