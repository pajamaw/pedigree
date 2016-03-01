class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.integer :family_tree_id
      t.string :name
      t.integer :father_id
      t.integer :mother_id
      t.integer :spouse_id
      t.string :gender

      t.timestamps
    end
  end
end
