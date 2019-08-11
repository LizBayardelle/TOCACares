json.extract! authorization, :id, :email, :admin, :committee, :account_created, :created_at, :updated_at
json.url authorization_url(authorization, format: :json)
