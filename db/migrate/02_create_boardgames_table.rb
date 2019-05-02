class CreateBoardgamesTable < ActiveRecord::Migration
  def change
    create_table :boardgames do |t|
      t.string :name
      t.integer :user_id
    end
  end
end