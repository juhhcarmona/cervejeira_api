class CreateCervejas < ActiveRecord::Migration
  def change
    create_table :cervejas do |t|
      t.string :estilo, null: false
      t.decimal :temperatura_max, null: false
      t.decimal :temperatura_min, null: false

      t.timestamps null: false
    end
  end
end
