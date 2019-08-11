json.extract! testimonial, :id, :category, :title, :body, :featured, :approved, :user_id, :created_at, :updated_at
json.url testimonial_url(testimonial, format: :json)
