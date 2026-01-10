# frozen_string_literal: true

# db/seeds/development/03_announcements.rb
# Rich sample announcements for development and testing
# Creates diverse listings across all categories with various statuses

puts "\n  📢 Seeding Announcements (Development Mode)..."

# Helper methods
def random_seller
  @sellers ||= Seller.all.to_a
  @sellers.sample
end

def find_category(name)
  # Try exact match first, then case-insensitive
  @categories ||= {}
  @categories[name] ||= Category.find_by(name: name) ||
                        Category.where('LOWER(name) = LOWER(?)', name).first ||
                        Category.first
end

def random_location
  SeedData::LOCATIONS.sample
end

def random_views
  rand(0..150)
end

# Comprehensive announcement data organized by category
ANNOUNCEMENTS_DATA = [
  # ==========================================
  # LIBROS Y APUNTES
  # ==========================================
  {
    title: 'Cálculo de Thomas 14va Edición',
    description: 'Libro de Cálculo de una variable de Thomas en excelente estado. Edición 14. Incluye código de acceso a recursos en línea (sin usar). Perfecto para Cálculo I y II. Sin rayaduras ni anotaciones.',
    price: 45.00,
    condition: :like_new,
    category: 'Libros y apuntes',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Apuntes completos de Estructura de Datos',
    description: 'Apuntes del curso de Estructura de Datos (FIEC). Incluye todos los temas: listas, pilas, colas, árboles, grafos, ordenamiento y búsqueda. Con ejercicios resueltos y código en C++/Java. 150 páginas impresas y encuadernadas.',
    price: 18.00,
    condition: :good,
    category: 'Libros y apuntes',
    location: 'FIEC'
  },
  {
    title: 'Python Crash Course 3rd Edition',
    description: 'Libro en inglés para aprender Python desde cero. Tercera edición actualizada. Incluye proyectos prácticos: juego, visualización de datos y aplicación web. Estado impecable.',
    price: 35.00,
    condition: :new_item,
    category: 'Libros y apuntes',
    location: 'Campus Prosperina'
  },
  {
    title: 'Física Universitaria Sears Zemansky Vol 1 y 2',
    description: 'Ambos volúmenes de Física Universitaria, 14va edición. Perfectos para Física I, II y III. Con solucionario incluido en PDF (se envía por email). Libros en buen estado, algunas páginas subrayadas con lápiz.',
    price: 55.00,
    condition: :good,
    category: 'Libros y apuntes',
    location: 'FCNM'
  },
  {
    title: 'Álgebra Lineal y sus Aplicaciones - David Lay',
    description: 'Libro de Álgebra Lineal de David Lay, 5ta edición. Excelente para el curso de Álgebra Lineal. Incluye acceso a MyLab Math. Libro casi nuevo, usado solo un semestre.',
    price: 40.00,
    condition: :like_new,
    category: 'Libros y apuntes',
    location: 'Campus Gustavo Galindo'
  },

  # ==========================================
  # ELECTRÓNICA
  # ==========================================
  {
    title: 'Laptop HP Pavilion Core i5 11va Gen',
    description: 'Laptop HP Pavilion 15, procesador Intel Core i5-1135G7, 8GB RAM DDR4, 512GB SSD NVMe, pantalla Full HD 15.6". Windows 11. Batería con 4-5 horas de duración. Incluye cargador original y funda protectora.',
    price: 520.00,
    condition: :good,
    category: 'Electrónica',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Calculadora HP Prime Graficadora',
    description: 'Calculadora graficadora HP Prime con pantalla táctil a color. Perfecta para cálculo, álgebra y estadística. Incluye funda original y cable USB. Funciona perfectamente.',
    price: 85.00,
    condition: :like_new,
    category: 'Electrónica',
    location: 'FCNM'
  },
  {
    title: 'Monitor LG 24" Full HD IPS',
    description: 'Monitor LG 24MK430H, 24 pulgadas, Full HD 1080p, panel IPS, 75Hz. AMD FreeSync. Ideal para programación y diseño. Incluye cables HDMI y de poder.',
    price: 120.00,
    condition: :good,
    category: 'Electrónica',
    location: 'Guayaquil Norte'
  },
  {
    title: 'Teclado Mecánico Redragon Kumara RGB',
    description: 'Teclado mecánico Redragon K552 Kumara con switches rojos. Retroiluminación RGB. Formato TKL (sin teclado numérico). Excelente para programar y gaming. 6 meses de uso.',
    price: 45.00,
    condition: :like_new,
    category: 'Electrónica',
    location: 'FIEC'
  },
  {
    title: 'Arduino Mega 2560 + Kit de Sensores',
    description: 'Arduino Mega 2560 original con kit completo de 37 sensores. Incluye: sensores de temperatura, humedad, ultrasonido, IR, luz, etc. Protoboard, cables jumper y caja organizadora. Ideal para proyectos de electrónica.',
    price: 65.00,
    condition: :new_item,
    category: 'Electrónica',
    location: 'FIEC'
  },
  {
    title: 'Audífonos Sony WH-1000XM4',
    description: 'Audífonos inalámbricos Sony WH-1000XM4 con cancelación de ruido activa. Color negro. Excelente calidad de sonido. Batería de 30 horas. Incluye estuche y cable auxiliar.',
    price: 180.00,
    condition: :like_new,
    category: 'Electrónica',
    location: 'Campus Gustavo Galindo'
  },

  # ==========================================
  # ROPA Y ACCESORIOS
  # ==========================================
  {
    title: 'Mochila The North Face Borealis 28L',
    description: 'Mochila The North Face Borealis de 28 litros. Compartimento acolchado para laptop hasta 15". Color gris/negro. Excelente estado, casi nueva. Perfecta para el campus.',
    price: 75.00,
    condition: :like_new,
    category: 'Ropa y accesorios',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Chompa Oficial ESPOL Talla M',
    description: 'Chompa oficial de ESPOL color azul marino, talla M. Nueva sin usar, con etiquetas. Material: algodón con poliéster.',
    price: 25.00,
    condition: :new_item,
    category: 'Ropa y accesorios',
    location: 'Centro de Estudiantes'
  },
  {
    title: 'Zapatos Nike Air Max 90 Talla 42',
    description: 'Nike Air Max 90 color blanco/negro, talla 42 (US 9). Usados pocas veces, en muy buen estado. Se venden porque me quedaron pequeños.',
    price: 65.00,
    condition: :good,
    category: 'Ropa y accesorios',
    location: 'Guayaquil Centro'
  },

  # ==========================================
  # DEPORTES
  # ==========================================
  {
    title: 'Raqueta de Tenis Wilson Pro Staff',
    description: 'Raqueta de tenis Wilson Pro Staff 97, 315g. Grip size 3. Incluye funda térmica y overgrips nuevos. Excelente para nivel intermedio-avanzado.',
    price: 95.00,
    condition: :good,
    category: 'Deportes',
    location: 'Canchas ESPOL'
  },
  {
    title: 'Balón de Fútbol Adidas Tiro League',
    description: 'Balón de fútbol Adidas Tiro League, tamaño 5. Usado en partidos de liga interna. Buen estado, mantiene bien la presión.',
    price: 28.00,
    condition: :good,
    category: 'Deportes',
    location: 'Canchas ESPOL'
  },
  {
    title: 'Set de Mancuernas Ajustables 20kg',
    description: 'Set de mancuernas ajustables de 2.5kg a 10kg cada una. Total 20kg. Incluye barra y discos intercambiables. Perfectas para ejercitarse en casa o dormitorio.',
    price: 55.00,
    condition: :like_new,
    category: 'Deportes',
    location: 'Guayaquil Norte'
  },

  # ==========================================
  # MUEBLES
  # ==========================================
  {
    title: 'Escritorio de Estudio con Estantes',
    description: 'Escritorio de madera MDF con estantes laterales. Medidas: 120cm largo x 60cm profundidad x 75cm alto. Color madera natural. Ideal para estudiar con espacio para libros y computadora.',
    price: 95.00,
    condition: :good,
    category: 'Muebles',
    location: 'Guayaquil Norte'
  },
  {
    title: 'Silla Ergonómica de Oficina',
    description: 'Silla ergonómica con soporte lumbar ajustable, reposabrazos regulables y altura ajustable. Ruedas de goma. Color negro. Perfecta para largas horas de estudio. Usada 8 meses.',
    price: 85.00,
    condition: :good,
    category: 'Muebles',
    location: 'Guayaquil Centro'
  },
  {
    title: 'Estantería de Metal 5 Niveles',
    description: 'Estantería metálica de 5 niveles, cada nivel soporta hasta 30kg. Medidas: 90cm ancho x 40cm profundidad x 180cm alto. Fácil de armar. Perfecta para dormitorio o departamento.',
    price: 45.00,
    condition: :like_new,
    category: 'Muebles',
    location: 'Guayaquil Sur'
  },

  # ==========================================
  # SERVICIOS
  # ==========================================
  {
    title: 'Tutorías de Cálculo I, II y III',
    description: 'Ofrezco tutorías personalizadas de Cálculo I, II y III. Estudiante de 9no semestre de Matemáticas con promedio 9.2. Metodología práctica con resolución de ejercicios. Disponible fines de semana y algunas tardes. Precio por hora de clase.',
    price: 10.00,
    condition: :new_item,
    category: 'Servicios',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Desarrollo Web Full Stack',
    description: 'Desarrollo aplicaciones web con React, Node.js y PostgreSQL. Landing pages, sistemas web, APIs. Precios accesibles para proyectos estudiantiles. Portfolio disponible. Entrega con código fuente y documentación.',
    price: 200.00,
    condition: :new_item,
    category: 'Servicios',
    location: 'Remoto/Virtual'
  },
  {
    title: 'Diseño de Logos y Branding',
    description: 'Diseño de identidad visual: logos, paleta de colores, tarjetas de presentación. Estudiante de Diseño Gráfico en FADCOM. 3 propuestas iniciales, revisiones ilimitadas hasta quedar satisfecho. Entrega en formatos editables.',
    price: 40.00,
    condition: :new_item,
    category: 'Servicios',
    location: 'FADCOM'
  },
  {
    title: 'Clases de Inglés Conversacional',
    description: 'Clases de inglés enfocadas en conversación y pronunciación. Certificado TOEFL iBT 105. Ideal para preparación de entrevistas, exámenes o viajes. Online o presencial. Precio por hora.',
    price: 12.00,
    condition: :new_item,
    category: 'Servicios',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Reparación de Computadoras y Laptops',
    description: 'Servicio de reparación: formateo, limpieza de virus, instalación de programas, cambio de pasta térmica, upgrades de RAM/SSD. Diagnóstico gratis. Atención a domicilio con costo adicional.',
    price: 15.00,
    condition: :new_item,
    category: 'Servicios',
    location: 'FIEC'
  },

  # ==========================================
  # INSTRUMENTOS MUSICALES
  # ==========================================
  {
    title: 'Guitarra Acústica Yamaha F310',
    description: 'Guitarra acústica Yamaha F310, perfecta para principiantes e intermedios. Cuerdas de acero. Incluye funda acolchada, correa, afinador cromático y capo. Estado impecable.',
    price: 130.00,
    condition: :like_new,
    category: 'Instrumentos musicales',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Teclado Casio CTK-3500',
    description: 'Teclado Casio CTK-3500, 61 teclas sensibles al tacto. 400 tonos, 100 ritmos. Conexión MIDI/USB. Incluye atril y adaptador de corriente. Ideal para aprender.',
    price: 150.00,
    condition: :good,
    category: 'Instrumentos musicales',
    location: 'Guayaquil Norte'
  },

  # ==========================================
  # VEHÍCULOS
  # ==========================================
  {
    title: 'Bicicleta de Montaña GW Aro 29',
    description: 'Bicicleta de montaña GW Lynx aro 29, marco de aluminio. 21 velocidades Shimano. Frenos de disco mecánicos. Color negro/verde. Bien mantenida, ideal para el campus.',
    price: 320.00,
    condition: :good,
    category: 'Vehículos',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Patineta Eléctrica Xiaomi',
    description: 'Patineta eléctrica Xiaomi Mi Electric Scooter Essential. Velocidad máx 20km/h, autonomía 20km. Plegable. Incluye cargador y candado. Perfecta para movilizarse en el campus.',
    price: 280.00,
    condition: :like_new,
    category: 'Vehículos',
    location: 'Campus Prosperina'
  },

  # ==========================================
  # HOGAR Y COCINA
  # ==========================================
  {
    title: 'Mini Refrigeradora Daewoo 3.2 pies',
    description: 'Mini refrigeradora Daewoo de 3.2 pies cúbicos, perfecta para dormitorio. Congelador pequeño. Bajo consumo eléctrico. Incluye bandejas y cajón para verduras.',
    price: 140.00,
    condition: :good,
    category: 'Hogar y cocina',
    location: 'Campus Gustavo Galindo'
  },
  {
    title: 'Microondas Samsung 20L',
    description: 'Microondas Samsung de 20 litros, 800W. Panel digital. Múltiples niveles de potencia. Función descongelar. En perfecto funcionamiento.',
    price: 65.00,
    condition: :good,
    category: 'Hogar y cocina',
    location: 'Guayaquil Centro'
  },
  {
    title: 'Set de Ollas Umco 7 Piezas',
    description: 'Juego de ollas Umco de aluminio antiadherente. 7 piezas: 3 ollas con tapa, 1 sartén. Poco uso, excelente estado. Ideales para departamento de estudiante.',
    price: 45.00,
    condition: :like_new,
    category: 'Hogar y cocina',
    location: 'Guayaquil Norte'
  },

  # ==========================================
  # OTROS
  # ==========================================
  {
    title: 'Maleta de Viaje Samsonite 24"',
    description: 'Maleta Samsonite de 24 pulgadas con 4 ruedas giratorias. Candado TSA integrado. Color azul. Usada en 2 viajes, excelente estado.',
    price: 95.00,
    condition: :like_new,
    category: 'Otros',
    location: 'Guayaquil Centro'
  },
  {
    title: 'Impresora HP DeskJet 2775',
    description: 'Impresora multifuncional HP DeskJet 2775: imprime, escanea y copia. WiFi integrado. Incluye cables y cartuchos con tinta (50% aprox). Perfecta para imprimir trabajos.',
    price: 55.00,
    condition: :good,
    category: 'Otros',
    location: 'FIEC'
  },

  # ==========================================
  # ITEMS VENDIDOS/RESERVADOS (para testing)
  # ==========================================
  {
    title: 'MacBook Air M1 2020 [VENDIDO]',
    description: 'MacBook Air con chip M1, 8GB RAM, 256GB SSD. Color gris espacial. En perfecto estado. Ya fue vendido.',
    price: 850.00,
    condition: :like_new,
    category: 'Electrónica',
    location: 'Campus Gustavo Galindo',
    status: :sold
  },
  {
    title: 'iPad Pro 11" 2021 [RESERVADO]',
    description: 'iPad Pro de 11 pulgadas, chip M1, 128GB WiFi. Incluye Apple Pencil 2da gen. Reservado, pendiente de pago.',
    price: 720.00,
    condition: :like_new,
    category: 'Electrónica',
    location: 'FIEC',
    status: :reserved
  },
  {
    title: 'Bicicleta Fixie Vintage [INACTIVO]',
    description: 'Bicicleta fixie estilo vintage. Publicación pausada temporalmente.',
    price: 180.00,
    condition: :good,
    category: 'Vehículos',
    location: 'Guayaquil Centro',
    status: :inactive
  }
].freeze

# Create announcements
created_count = 0
skipped_count = 0
error_count = 0

ANNOUNCEMENTS_DATA.each_with_index do |data, index|
  # Check if announcement with same title exists
  if Announcement.exists?(title: data[:title])
    skipped_count += 1
    puts "    ⏭️  Exists: #{data[:title][0..40]}..."
    next
  end

  begin
    seller = random_seller
    category = find_category(data[:category])

    unless category
      puts "    ⚠️  Category not found: #{data[:category]}"
      next
    end

    announcement = Announcement.create!(
      title: data[:title],
      description: data[:description],
      price: data[:price],
      condition: data[:condition],
      category: category,
      seller: seller,
      location: data[:location] || random_location,
      status: data[:status] || :active
    )

    # Simulate realistic view counts
    views = random_views
    announcement.update_column(:views_count, views)

    created_count += 1
    status_emoji = case announcement.status
                   when 'active' then '🟢'
                   when 'sold' then '🔴'
                   when 'reserved' then '🟡'
                   else '⚪'
                   end

    puts "    #{status_emoji} #{index + 1}. #{announcement.title[0..35]}... ($#{announcement.price})"
  rescue ActiveRecord::RecordInvalid => e
    error_count += 1
    puts "    ❌ Error: #{data[:title][0..30]}... - #{e.message}"
  rescue StandardError => e
    error_count += 1
    puts "    ❌ Error: #{data[:title][0..30]}... - #{e.class}: #{e.message}"
  end
end

# Summary statistics
puts "\n  📊 Announcement Summary:"
puts "    • Total in database: #{Announcement.count}"
puts "    • Created this run: #{created_count}"
puts "    • Skipped (existing): #{skipped_count}"
puts "    • Errors: #{error_count}"

puts "\n  📈 Status Distribution:"
Announcement.group(:status).count.each do |status, count|
  emoji = case status
          when 'active' then '🟢'
          when 'sold' then '🔴'
          when 'reserved' then '🟡'
          else '⚪'
          end
  puts "    #{emoji} #{status.capitalize}: #{count}"
end

puts "\n  🏷️  Condition Distribution:"
Announcement.group(:condition).count.each do |condition, count|
  puts "    • #{condition.to_s.titleize}: #{count}"
end

puts "\n  📂 By Category:"
Category.left_joins(:announcements)
        .group('categories.name')
        .count('announcements.id')
        .sort_by { |_, v| -v }
        .each do |name, count|
  puts "    • #{name}: #{count}"
end

puts "\n  💰 Price Statistics:"
if Announcement.any?
  prices = Announcement.pluck(:price)
  puts "    • Min: $#{prices.min}"
  puts "    • Max: $#{prices.max}"
  puts "    • Average: $#{(prices.sum / prices.count).round(2)}"
end
