class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to(@user, flash:{notice: "Account created. Please log in now."})
    else
      flash[:alert] = "Error creating account: #{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to(@user, flash:{notice: "Account is updated successfully."})
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to(statuses_path, flash:{notice: "Account is deleted"})
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
