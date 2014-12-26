json.array!(@tracks) do |track|
  json.extract! track, 
  json.url track_url(track, format: :json)
end
