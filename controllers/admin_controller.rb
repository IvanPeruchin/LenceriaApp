# frozen_string_literal: true

# AdminController es el responzable de menu, de lenceria, de deportivos y de modificaciones
class AdminController < Sinatra::Application

  get '/admin' do
    erb :admin
  end

  get '/load_item' do
    erb :load_item
  end

  post '/load_item' do
    item_attributes = {
      name: params[:name],
      price: params[:price],
      description: params[:description],
      category: params[:category],
      in_stock: true
    }
    colors = params[:colors]
    sizes = params[:sizes]
    

    #creo el elemento en DB
    item = Item.create(item_attributes)

    # Busco los id de las descripciones para las Claves foraneas
    colors_id = []
    sizes_id = []

    (0...colors.length).each do |i|
      colors_id << Color.find_by(name: colors[i])&.id
    end
    
    (0...sizes.length).each do |i|
      sizes_id << Size.find_by(number: sizes[i])&.id
    end

    # Creo la descripcion del elemento
    max_length = [colors.length, sizes.length].max

    (0...max_length).each do |i|
      color_id = colors_id[i] || nil
      size_id = sizes_id[i] || nil

      ItemDescription.create(item_id: item.id, color_id: color_id, size_id: size_id, category: params[:category])
    end

    redirect '/load_item'
  end

  get '/delete_item' do
    erb :delete_item
  end

  get '/modifie_item' do
    erb :modifie_item
  end


end
