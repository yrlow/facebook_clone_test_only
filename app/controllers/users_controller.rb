class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(valid_params)

    if @user.save

    else

    end

  end

  def edit
  end

  def update
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def valid_params
    params.require(:user).permit(:name, :email)
  end
end
