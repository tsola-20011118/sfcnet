Rails.application.routes.draw do

  get "user/talk/index" => "user#talkindex" #しゃべっている人一覧画面
  get "user/talk/:id" => "user#talk" #:idの人とのトーク画面
  get "user/logout" => "user#logout" #ログアウト
  get "user/new" => "user#new" #新規登録画面
  get "user/create" => "user#create" #画面表示なし
  get 'user/login' => "user#login" #login入力画面
  get 'user/logined'#画面表示なし
  get "user/:id/editer" => "user#editer" #画面表示なし
  get "user/:id/edit" => "user#edit" #編集画面
  get "user/:id/destroy" => "user#destroy" #ユーザー情報削除
  get "user/:id" => "user#mypage" #ユーザー情報表示ページ

  get "taxi/exit" => "taxi#exit" #タクシーを諦めるページ
  get "taxi/checkD/:id" => "taxi#checkD"#誘われた人から承認したあとのページ（未完成,未検証）
  get "taxi/check" => "taxi#check"#誘われた人から承認するページ
  get "taxi/match/:id" => "taxi#match" #誘うか確定した後のページ
  get "taxi/connect/:id" => "taxi#connect" #誘うか選択するページ
  get "taxi/waiting" => "taxi#waiting" #待機している人一覧の表示ページ
  get "taxi/wait" => "taxi#wait" #待機状態にする、画面表示なし
  # get "taxi" => "taxi#taxi"　使わない？

  get "home/contact" => "home#contact"#contactページ
  get "home/top" => "home#top" #topページ
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/" => "home#top" #topページ

  
end
