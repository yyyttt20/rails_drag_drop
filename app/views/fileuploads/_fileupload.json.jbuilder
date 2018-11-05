json.extract! fileupload, :id, :name, :filepath, :thumbnail_img_path, :created_at, :updated_at
json.url fileupload_url(fileupload, format: :json)
