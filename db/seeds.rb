# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cervejas = [
  {
    estilo: "Weissbier",
    temperatura_max: 3,
    temperatura_min: -1
  },
  {
    estilo: "Pilsens",
    temperatura_max: 4,
    temperatura_min: -2
  },
  {
    estilo: "Weizenbier",
    temperatura_max: 6,
    temperatura_min: -4
  },
  {
    estilo: "Red ale",
    temperatura_max: 5,
    temperatura_min: -5
  },
  {
    estilo: "India pale ale",
    temperatura_max: 7,
    temperatura_min: -6
  },
  {
    estilo: "IPA",
    temperatura_max: 10,
    temperatura_min: -7
  },
  {
    estilo: "Dunkel",
    temperatura_max: 2,
    temperatura_min: -8
  },
  {
    estilo: "Imperial Stouts",
    temperatura_max: 13,
    temperatura_min: -10
  },
  {
    estilo: "Brown ales",
    temperatura_max: 14,
    temperatura_min: 0
  },
]


cervejas.each  do |cerveja|
  Cerveja.create({
    estilo: cerveja[:estilo],
    temperatura_max: cerveja[:temperatura_max],
    temperatura_min: cerveja[:temperatura_min],
  })
end