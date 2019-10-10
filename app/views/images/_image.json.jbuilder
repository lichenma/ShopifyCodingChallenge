json.extract! image, :id, :title, :created_by, :visibility, :content, :created_at, :updated_at
json.url image_url(image, format: :json)
