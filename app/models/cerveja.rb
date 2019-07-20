class Cerveja < ActiveRecord::Base
  validates :estilo, :temperatura_max, :temperatura_min,  presence: true
  validate :temperaturas

  def self.cerveja_por_temperatura(temperatura)
    avg = "temperatura_max+temperatura_min)/2"

    query = "SELECT * FROM cervejas WHERE ABS(#{temperatura} - (#{avg}) = (SELECT MIN(ABS(#{temperatura} - (#{avg})) FROM cervejas) ORDER BY estilo ASC LIMIT 1"

    ActiveRecord::Base.connection.execute(query).first
  end

  private

  def temperaturas
    if self.temperatura_min.present? && self.temperatura_max.present? && self.temperatura_min > self.temperatura_max
      errors.add(:temperatura_min, "precisa ser menor que a 'temperatura_max'")
    end
  end

end
