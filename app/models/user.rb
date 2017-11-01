class User < ActiveRecord::Base
 :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  include OrderHelper
  include ActionView::Helpers::NumberHelper
  validates_format_of :email, {:with => /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/,
    message: " is required to be a valid email address"}

  before_create :build_default_account

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

  protected
  def confirmation_required?
    true
  end

  #def send_confirmation_instructions
  # stops Devise from automatically sending a confirmation email
  #end

  private

  def build_default_account
    build_account
    true
  end
end
