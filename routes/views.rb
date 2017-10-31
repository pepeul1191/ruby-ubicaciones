class MyApp < Sinatra::Base
    get '/home' do
        erb :'home/index', :layout => :'layouts/blank', :locals => { :tiempo => Time.now }
    end
end