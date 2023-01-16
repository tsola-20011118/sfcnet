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

  get "taxi/exit" => "taxi#exit"
  get "taxi/check" => "taxi#check"
  get "taxi/match/:id" => "taxi#match"
  get "taxi/connect/:id" => "taxi#connect"
  get "taxi/waiting" => "taxi#waiting"
  get "taxi/wait" => "taxi#wait"
  get "taxi" => "taxi#taxi"

  get "home/contact" => "home#contact"
  get "home/top" => "home#top"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/" => "home#top"
end
