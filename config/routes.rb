require "#{Rails.root}/app/api/base"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: proc { [404, {}, ["Not found."]] }
  mount API::Base => '/'

end
