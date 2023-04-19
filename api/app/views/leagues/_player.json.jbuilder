json.(player, :id, :rating, :username, :created_at)

if local_assigns[:include]&.include? :user
  json.user do
    json.partial! "users/user", user: player.user
  end
end