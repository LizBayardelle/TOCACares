json.extract! response, :id, :user_id, :message_id, :body, :created_at, :updated_at
json.url response_url(response, format: :json)
