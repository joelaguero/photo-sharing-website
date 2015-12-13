class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
    	t.string :id
    	t.string :user_id
    	t.string :date_time
    	t.string :file_name
    	t.timestamps
    end
  end
end
