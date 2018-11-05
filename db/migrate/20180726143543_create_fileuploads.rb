class CreateFileuploads < ActiveRecord::Migration[5.1]
  def change
    create_table :fileuploads do |t|
      t.string :name
      t.string :filepath
      t.string :thumbnail_img_path

      t.timestamps
    end
  end
end
