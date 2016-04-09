Rails.application.routes.draw do

  mount MessageBroker::API => '/'
 
end
