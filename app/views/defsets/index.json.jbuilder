json.array!(@defsets) do |defset|
  json.extract! defset, :id, :name, :value
  json.url defset_url(defset, format: :json)
end
