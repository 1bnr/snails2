class Account < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  has_many :deposits, dependent: :delete_all, validate: false

  def calculate_deposits
    amount = 0
    deposits.each do |deposit|
      amount += deposit.amount
    end
    amount
  end

  def formatted_total_deposits
    number_to_currency(calculate_deposits)
  end
end
