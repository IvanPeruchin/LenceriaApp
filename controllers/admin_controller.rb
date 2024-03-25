# frozen_string_literal: true

# AdminController es el responzable de menu, de lenceria, de deportivos y de modificaciones
class AdminController < Sinatra::Application

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
    upload_descrptions_id(params[:colors], params[:sizes], item.id)

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
  
    if params[:file] && params[:file][:filename]
      filename = params[:file][:filename]
      target_path = File.join(settings.public_folder, 'front', params[:category], filename)
      item.image = target_path&.sub('/src/public', '')
    end
  
    # Verificar y agregar parámetros solo si no están vacíos en el formulario
    item.name = params[:name].empty? ? item.name : params[:name]
    item.price = params[:price].empty? ? item.price : params[:price].to_f
    item.description = params[:description].empty? ? item.description : params[:description]
    item.in_stock = params[:in_stock].empty? ? item.in_stock : (params[:in_stock] == "true")
  
    # Actualizar la base de datos solo si hay cambios
    item.save if item.changed?

    puts "Received params: #{params.inspect}"

    if not params[:colors]&.empty?
      get_colors(params[:colors], item.id) 
    end
    if params[:sizes]&.empty? 
      get_sizes(params[:sizes], item.id) 
    end 
    
    redirect '/modifie_item'
    end
    
    # --------- METODOS ------------
    def get_colors(colors, item_id)
      item_descriptions = ItemDescription.where(item_id: item_id)
      colors_ids = colors&.map { |color| Color.find_by(name: color)&.id }
    
      item_descriptions.each_with_index do |item_description, index|
        color_id = colors_ids[index] unless colors_ids.nil?
    
        item_description.update(color_id: color_id)
      end
    end
    
    def get_sizes(sizes, item_id)
      item_descriptions = ItemDescription.where(item_id: item_id)
      sizes_ids = sizes&.map { |size| Size.find_by(number: size)&.id }
    
      item_descriptions.each_with_index do |item_description, index|
        size_id = sizes_ids[index] unless sizes_ids.nil?
    
        item_description.update(size_id: size_id)
      end
    end
    
  
  
  def upload_descrptions_id(colors, sizes, id)
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

      ItemDescription.create(item_id: id, color_id: color_id, size_id: size_id)
    end
  end

  # Chequea si ese item existe
  def item_exist(item_id)
    return Item.find_by(id: item_id).present?
  end
    
    

end
