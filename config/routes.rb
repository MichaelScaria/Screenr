Screenr::Application.routes.draw do
  namespace :api do
    post 'signup' => 'users#signup'
    post 'verify' => 'users#verify'
    post 'area_code' => 'users#area_code'
    post 'initial' => 'users#initial'
    post 'state' => 'users#state'
    post 'purchase' => 'users#purchase'
    post 'inbox' => 'users#inbox'
    post 'messages' => 'users#messages'
  end
end
