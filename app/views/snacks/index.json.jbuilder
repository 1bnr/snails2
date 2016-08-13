json.array!(@snacks) do |snack|
  json.extract! snack, :id, :name, :price
  json.url snack_url(snack, format: :json)
end
