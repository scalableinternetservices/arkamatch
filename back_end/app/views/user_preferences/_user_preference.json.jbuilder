json.extract! user_preference, :id, :name, :interest, :created_at, :updated_at
json.url user_preference_url(user_preference, format: :json)
