class Api::V1::AuthController < ApplicationController
  skip_before_action :authorized, :only => [:signup, :signin]

  def profile
    @user = current_user
    render json: { :user => @user }, :status => :accepted
  end

  def signup
    binding.pry
    @user = User.create(user_credential_params)
    if @user.valid?
      @token = encode_token(:user_id => @user.id)
      render json: { :user => @user, :jwt => @token }, :status => :created
    else
      render json: { :error => 'Failed to create user' }, :status => :not_acceptable
    end
  end

  def signin
    binding.pry
    @user = User.find_by(:email => user_credential_params[:email])
    # authenticate method comes from bcrypt
    if @user && @user.authenticate(user_credential_params[:password])
      @token = encode_token({ :user_id => @user.id })
      render json: { :user => @user, :jwt => @token }, :status => :accepted
    else
      render json: { :error => 'Invalid credentials' }, :status => :unauthorized
    end
  end

  private

  def user_credential_params
    params.permit(:email, :password, :password_confirmation)
  end
end
