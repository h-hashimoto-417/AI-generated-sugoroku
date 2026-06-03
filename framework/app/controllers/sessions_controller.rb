class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(uname: params[:uname])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/home"
    else
      @error_message = "ユーザー名またはパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/home"
  end
end