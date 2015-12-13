class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.integer :id
    	t.integer :photo_id
    	t.string :user_id
    	t.string :date_time
    	t.text :comment
        t.timestamps
    end
  end
end
