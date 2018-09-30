Rails.application.routes.draw do
  resource :subscriptions, :only => [:create]
end
