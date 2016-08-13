class Order < ActiveRecord::Base
  include OrderHelper
  has_many :line_items, dependent: :delete_all, validate: false
  belongs_to :user

  def calculate_order_sum
    sum_order
  end
end
