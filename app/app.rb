ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  get '/' do
    redirect :'signup'
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    User.create(username: params[:username], email: params[:email], password: params[:password])
    redirect '/welcome'
  end

  get '/welcome' do
    erb :welcome
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url],
    title: params[:title])
    params[:tags].split(", ").each do |each_tag|
      link.tags << Tag.create(name: each_tag)
    end
    link.save
    redirect :links
  end

  get '/tags' do
    @links = Link.all.split(", ")
    erb :'tags/index'
  end

  get '/tags/:tag' do
    tag = Tag.all(name: params[:tag])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  run! if app_file == $0
end
