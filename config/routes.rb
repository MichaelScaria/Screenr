Screenr::Application.routes.draw do
  namespace :api do
    post 'signup' => 'users#signup'
  end
end
