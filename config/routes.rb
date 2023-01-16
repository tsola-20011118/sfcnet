Rails.application.routes.draw do

  get "user/talk/index" => "user#talkindex" #0,
  get "user/talk/:id" => "user#talk" #0
  get "user/logout" => "user#logout" #0
  get "user/new" => "user#new" #0
  get "user/create" => "user#create" #0（テンプレートなし）
  get 'user/login' => "user#login"
  get 'user/logined'
  get "user/:id/editer" => "user#editer"
  get "user/:id/edit" => "user#edit"
  get "user/:id/destroy" => "user#destroy"
  get "user/:id" => "user#mypage"

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
