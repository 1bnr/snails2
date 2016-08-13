module OrderHelper
  include ActionView::Helpers::NumberHelper
  def sum_user_orders
    sum = 0
    orders.each do |order|
      order.line_items.each do |line|
        sum += line.purchase_price
      end
    end
    sum
  end

  def sum_all_user_orders(user)
    sum = 0
    @orders.each do |order|
      order.line_items.each do |line|
        sum += line.purchase_price
      end
    end
    number_to_currency(sum)
  end

 def sum_order
    sum = 0
    line_items.each do |line|
      sum += line.purchase_price
    end
    number_to_currency(sum)
  end
end

