class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.integer :family_tree_id
      t.string :name

      t.timestamps
    end
  end
end
