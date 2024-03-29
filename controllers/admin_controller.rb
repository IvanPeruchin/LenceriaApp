# frozen_string_literal: true

# AdminController es el responzable de menu, de lenceria, de deportivos y de modificaciones
class AdminController < Sinatra::Application
  before ['/admin', '/load_item', '/eliminar_item', '/modificar_item', '/search_item/:option_selected'] do
    redirect '/login' unless session[:admin] # Redirige a la página de inicio de sesión si el admin no está autenticado
  end

  get '/admin' do
    erb :admin
  end

  get '/load_item' do
    @colors = Color.all
    @sizes = Size.all
    
    erb :load_item
  end

  post '/load_item' do
    # Obtengo la imagen
    filename = params[:file][:filename]
    target_path = File.join(settings.public_folder, 'front', params[:category], filename)

    item_attributes = {
      name: params[:name],
      price: params[:price],
      description: params[:description],
      category: params[:category],
      image: target_path.sub('/src/public', ''),
      in_stock: true
    }

    #creo el elemento en DB
    item = Item.create(item_attributes)
    create_descriptions_id(params[:colors], params[:sizes], item.id)

    redirect '/load_item'
  end

  get '/search_item/:option_selected' do
    @mode = params[:option_selected]
    erb :search_item
  end

  post '/search_item' do
    session[:id_item] = params[:id]
    redirect "/#{params[:mode]}_item"
  end

  get '/eliminar_item' do
    if item_exist(session[:id_item])
      @item = Item.find_by(id: session[:id_item])
      erb :eliminar_item
    else 
      redirect '/admin'
    end
  end

  delete '/eliminar_item' do
    item = Item.find(session[:id_item])
    item.destroy
    
    redirect '/search_item/eliminar'
  end


  get '/modificar_item' do
    if item_exist(session[:id_item])
      @colors = Color.all
      @sizes = Size.all
      erb :modificar_item
    else 
      redirect '/admin'
    end
  end

  post '/modificar_item' do  
    item = Item.find_by(id: session[:id_item])
    
    set_image(item)
    set_item_value(item)
    
    redirect '/admin'
  end

  get '/logout' do
    session[:admin] = false
    redirect '/'
  end
  
    # --------- METODOS ------------
    # Actualiza color y talles
    def update_item_descriptions(colors, sizes, item_id)
      item_descriptions = ItemDescription.where(item_id: item_id)
    
      colors_ids = colors&.map { |color| Color.find_by(name: color)&.id }
      sizes_ids = sizes&.map { |size| Size.find_by(number: size)&.id }
    
      item_descriptions.each_with_index do |item_description, index|
        color_id = colors_ids.present? ? colors_ids[index] : item_description.color_id
        size_id = sizes_ids.present? ? sizes_ids[index] : item_description.size_id
    
        item_description.update(color_id: color_id, size_id: size_id)
      end
    end

    # Actualiza la imagen
    def set_image(item)
      if params[:file] && params[:file][:filename]
        filename = params[:file][:filename]
        target_path = File.join(settings.public_folder, 'front', item.category , filename)
        item.image = target_path&.sub('/src/public', '')
      end
    end

    # Actualiza los valores
    def set_item_value(item)
      item.name = params[:name].empty? ? item.name : params[:name]
      item.price = params[:price].empty? ? item.price : params[:price].to_f
      item.description = params[:description].empty? ? item.description : params[:description]
      item.in_stock = params[:in_stock].empty? ? item.in_stock : (params[:in_stock] == "true")

      item.save if item.changed?
      
      if params[:colors].present? || params[:sizes].present?
        update_item_descriptions(params[:colors], params[:sizes], item.id) 
      end    
    end
    
    # Carga los datos de un item
    def create_descriptions_id(colors, sizes, id)
      colors_ids = colors&.map { |color| Color.find_by(name: color)&.id }
      sizes_ids = sizes&.map { |size| Size.find_by(number: size)&.id }
    
      max_length = [colors.length, sizes.length].max
    
      (0...max_length).each do |i|
        color_id = colors_ids[i] || nil
        size_id = sizes_ids[i] || nil
    
        ItemDescription.create(item_id: id, color_id: color_id, size_id: size_id)
      end
    end
    

  # Chequea si ese item existe
  def item_exist(item_id)
    return Item.find_by(id: item_id).present?
  end
    
    

end
