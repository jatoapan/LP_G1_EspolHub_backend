# frozen_string_literal: true

# db/seeds/shared/categories_data.rb
# Shared category definitions for ESPOL Hub marketplace
# These categories are specific to the ESPOL university community needs

module SeedData
  CATEGORIES = [
    {
      name: 'Libros y Apuntes',
      description: 'Libros de texto, apuntes de clases, material de estudio, guías académicas',
      icon: 'book'
    },
    {
      name: 'Electrónica',
      description: 'Laptops, tablets, calculadoras científicas, componentes electrónicos, periféricos',
      icon: 'laptop'
    },
    {
      name: 'Ropa y Accesorios',
      description: 'Ropa, zapatos, mochilas, accesorios, uniformes',
      icon: 'shirt'
    },
    {
      name: 'Deportes',
      description: 'Equipamiento deportivo, ropa deportiva, accesorios para ejercicio',
      icon: 'dumbbell'
    },
    {
      name: 'Muebles',
      description: 'Muebles para dormitorios, escritorios, sillas de estudio, estanterías',
      icon: 'chair'
    },
    {
      name: 'Servicios',
      description: 'Tutorías académicas, diseño gráfico, programación, traducciones, asesorías',
      icon: 'wrench'
    },
    {
      name: 'Instrumentos Musicales',
      description: 'Guitarras, teclados, equipos de audio, accesorios musicales',
      icon: 'music'
    },
    {
      name: 'Vehículos',
      description: 'Bicicletas, motos, patinetas, accesorios para transporte',
      icon: 'bike'
    },
    {
      name: 'Hogar y Cocina',
      description: 'Utensilios de cocina, electrodomésticos pequeños, artículos del hogar',
      icon: 'home'
    },
    {
      name: 'Otros',
      description: 'Artículos diversos que no encajan en otras categorías',
      icon: 'box'
    }
  ].freeze

  # ESPOL Faculties for reference
  FACULTIES = %w[FIEC FCNM FIMCP FIMCBOR FCSH FADCOM ESPAE FCV FICT].freeze

  # Common locations within ESPOL
  LOCATIONS = [
    'Campus Gustavo Galindo',
    'Campus Prosperina',
    'Campus Las Peñas',
    'FIEC',
    'FCNM',
    'FIMCP',
    'FADCOM',
    'FCSH',
    'Biblioteca Central',
    'Centro de Estudiantes',
    'Canchas ESPOL',
    'Guayaquil Norte',
    'Guayaquil Centro',
    'Guayaquil Sur',
    'Remoto/Virtual'
  ].freeze
end
