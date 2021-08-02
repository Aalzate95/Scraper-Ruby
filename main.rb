require 'open-uri' # Importa gema
require 'nokogiri' #Importa gema nokogiri
require 'csv' # Importa gema

CSV.open('confesiones.csv', 'wb') do |csv| # abre un archivo csv en modo escritura
  csv << %w[Nro Autor Fecha Hora nrolikes nrodislikes nroComentarios texto]  # Establece los nombres de las columnas
  conf=0; pagina=1 # Inicialización de variables
  while (conf<100) # inicializa bucle para recorrer acorde a las variables inicializadas 
    puts "Scrapeando la url https://confiesalo.net/?page=#{pagina}..." # Imprime mensaje con dirección url que contiene el numero de pagina a analizar.
    link = "https://confiesalo.net/?page=#{pagina}" # Almacena url en la variable link
    confiesaloHTML = open(link) # Abre la url almacenada en link con la función open de la gema open-uri y lo almacena en la variable confiesaHTML
    datos = confiesaloHTML.read # Lee todo el texto html del link almacenado en confiesaloHTML
    parsed_content = Nokogiri::HTML(datos) # Utiliza la gema Nogokiri para parsear de forma más sencilla el Html
    inf_container = parsed_content.css('.infinite-container') # extrae el div con class "infinite-container" del html
    inf_container.css('.infinite-item').each do |confesions| # recorre el contenido de inf_container e inicializa la varible confesions para el mismo.
      header = confesions.css('div div.row').css('.meta__container--without-image').css('.row') # Extrae mediante los class las sección header del html

      bottom = confesions.css('div.row').css('.read-more') # Extrae mediante los class las sección bottom del html
      id_author = header.css('.meta__info').css('.meta__author').css('a').css('a:nth-child(3)').inner_text[1..-1] # De la sección header extrae el id del author usando los class del html y 
      # utiliza inner_text para extraer el texto del html

      author = header.css('.meta__info').css('.meta__author').at_css('a').inner_text[0..6] # De la sección header extrae el usuario/nombre del author usando los class del html y 
      # utiliza inner_text para extraer el texto del html

      date = header.css('.meta__info').css('.meta__date').inner_text.strip.split(' ') # [June, 9, 2020, 2:15 p.m.]  De la sección header extrae el fecha de publicación usando los class del html y 
      # utiliza inner_text para extraer el texto del html y lo limpia con la función strip, eliminando los espacios vacios iniciales y finales en caso de existir, luego crea un arreglo de los elementos
      # Separados por un espacio
      
      if !date[5].nil? # comprueba que la variable date en la posición 5 sea diferente de nil, es decir que sea un objeto de la instancia nilClass.
        strFecha = date[1] + ' ' + date[2] + ' ' + date[3][0..3] # da formato a la fecha y lo almacena en una variable
        strHour = date[4] + ' ' + date[5] # da formato a la hora y lo almacena en una variable
      else # en caso de que la condición sea falsa
        strFecha = nil #  establece un objeto de tipo nil para la fecha
        strHour = nil # establece un objeto de tipo nil para la hora
        end # finaliza la condición
      content = confesions.css('div.row').css('.post-content-text').inner_text.gsub("\n", '') # extrae el texto contenido en las class div.row y .post-content-text del html 

      nrolikes = bottom.css('span').css("#votosup-#{id_author}").inner_text # extrae el texto de numero de likes de la sección bottom del html

      nrodislikes = bottom.css('span').css("#votosdown-#{id_author}").inner_text # extrae el texto de numero de dislikes de la sección bottom del html

      nroComentarios = rand(1..100) # establece de forma aleatoria el numero de comentarios del 1 al 100

      csv << [conf.to_s,author.to_s, strFecha.to_s, strHour.to_s, nrolikes.to_i, nrodislikes.to_i, nroComentarios.to_i ,content.to_s] # Escribe los valores en el archivo csv
      conf+=1 # aumenta en 1 el contador para el siguiente ciclo del bucle
      # puts id.class
    end # termina el bucle do
    pagina+=1 # Aumenta en 1 el contador de paginas
  end # termina el ciclo while
  puts "Resuelto Reto RR - Parte 1... enter" # imprime mensaje de resulto
  puts "Ha superado la primera fase... Felicitaciones :)" # imprime mensaje de reto superado
end # termina o cierra la apertura del csv