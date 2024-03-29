class ChangePriceColumn < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE items
      ALTER COLUMN price TYPE real USING (price::real)
    SQL
  end
end
