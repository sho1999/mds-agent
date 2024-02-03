class CreateDailyReports < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_reports do |t|
      t.date :date
      t.integer :appointments
      t.integer :contracts
      t.integer :dms
      t.references :agent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
