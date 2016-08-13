json.array!(@orders) do |order|
  json.extract! order, :id, :price
  json.url order_url(order, format: :json)
end
