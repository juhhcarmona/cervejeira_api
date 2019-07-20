FactoryBot.define do
  factory :cerveja do
    estilo { Faker::Lorem.word }
    temperatura_max { (0..15).to_a.sample }
    temperatura_min { (-10..0).to_a.sample }
  end
end
