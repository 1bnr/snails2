class Deposit < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  def get_formatted_amount
    number_to_currency(amount)
  end
end
