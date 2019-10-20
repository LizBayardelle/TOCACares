json.extract! message, :id, :from_user_id, :user_id, :subject, :message, :read, :ref_application_type, :ref_application_id, :issue_closed, :created_at, :updated_at
json.url message_url(message, format: :json)
