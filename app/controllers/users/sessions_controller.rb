class Users::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create]

  def show
    if current_user
      @total_deposits = current_user.get_formatted_deposit_total
      @order_total = current_user.get_formatted_order_total
      @running_total = current_user.calculate_running_balance
      @user = current_user
    else
      redirect_to new_user_session_url
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
