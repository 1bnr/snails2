include ActionView::Helpers::NumberHelper 

class Snack < ActiveRecord::Base
  def get_formatted_price
    number_to_currency(price)
  end
end
