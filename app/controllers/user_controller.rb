class UserController < ApplicationController

  
  def login
    
  end

  def logined
    @loginuser = User.find_by(mail: params[:mail]);
    if @loginuser.passward == params[:passward]
      session[:id] = @loginuser.id;
      redirect_to("/user/#{session[:id]}");
    end
  end

  def logout
    if session[:id] == nil
      flash[:error] = "ログインしてください"
      redirect_to("/user/login");
    else
      session[:id] = nil;
      redirect_to("/home/top");
    end
  end

  def new
  end

  def create
    @user = User.new();
    @user.name = params[:name];
    @user.age = params[:age];
    @user.mail = params[:mail];
    @user.passward = params[:passward];
    @user.sex = params[:sex];
    @user.taxi = false;
    @user.save
    if @user.save
      session[:id] = @user.id;
      redirect_to("/user/#{session[:id]}");
    end
  end

  def mypage
    @pageuser = User.find_by(id: params[:id]);
  end

  def edit
    if session[:id] == nil || User.find_by(id: params[:id]).id != @user.id
      flash[:error] = "不正なアクセスを検出しました";
      redirect_to("/home/top");
    end
  end

  def editer
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
    end
  end

  def destroy
    if session[:id] == nil || User.find_by(id: params[:id]).id != @user.id
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
      @touser = User.find_by(id: params[:id]);
      #どちらも誘い合っている時のTaxiconnect削除（この時マッチングしている）
      if Taxiconnect.find_by(to:params[:id], from:session[:id]) && Taxiconnect.find_by(from:params[:id], to:session[:id])
        Taxiconnect.find_by(to:@user, from:@touser.id).destroy;
        Taxiconnect.find_by(to:@touser, from:@user.id).destroy;
        flash[:error] = "マッチングしました！待ち合わせ場所を決めましょう！"
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
      #既にTalkflagがあるとき（これまでにマッチングしたことがある）チャット画面を表示
      if @talkflag
        @flag = @talkflag.id;
        @messages = (Talk.where(flag: @flag).order(created_at: :desc).limit(5));
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
    else #ログインうユーザーがいる時の処理
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
