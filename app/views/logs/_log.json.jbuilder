json.extract! log, :id, :category, :action, :automatic, :subject, :subject_category, :subject_id, :taken_by_user, :user_id, :created_at, :updated_at
json.url log_url(log, format: :json)
