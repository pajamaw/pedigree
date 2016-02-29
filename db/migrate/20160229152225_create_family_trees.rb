class CreateFamilyTrees < ActiveRecord::Migration
  def change
    create_table :family_trees do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
