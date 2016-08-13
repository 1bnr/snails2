class User < ActiveRecord::Base
  include OrderHelper
  include ActionView::Helpers::NumberHelper
  validates_format_of :email, {:with => /\A([^@\s]+)@.*(umn\.edu)\z/,
    message: " is required to be a umn.edu address"}

  before_create :build_default_account
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders
  has_one :account

  def calculate_running_balance
    order_total = sum_user_orders
    deposits = account.calculate_deposits
    running_balance = deposits - order_total
    number_to_currency(running_balance)
  end

  def get_formatted_order_total
    deposits = sum_user_orders
    number_to_currency(deposits)
  end

  def get_formatted_deposit_total
    order_total = account.calculate_deposits
    number_to_currency(order_total)
  end

  private

  def build_default_account
    build_account
    true
  end
end
