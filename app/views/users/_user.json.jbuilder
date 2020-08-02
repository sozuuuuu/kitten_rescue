json.extract! user, :id, :name, :uid, :created_at, :updated_at
json.url user_url(user, format: :json)
