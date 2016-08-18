class SessionsController < ApplicationController  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to(statuses_path, flash:{notice: "Welcome, #{user.email}!"})
    else
      flash[:alert] = "Please log in again"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
