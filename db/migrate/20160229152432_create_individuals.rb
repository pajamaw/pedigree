class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.integer :family_tree_id
      t.string :name
      t.string :father
      t.string :mother

      t.timestamps
    end
  end
end
