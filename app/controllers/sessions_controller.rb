class SessionsController < ApplicationController
  def new
    render 'new'
  end

  def auth
    mg_params = params[:moviegoer]
    mg = Moviegoer.find_by_email mg_params[:email]
    if mg && mg.authenticate(mg_params[:password])
      session[:current_mg_id] = mg.id
      redirect_to movies_path
    else
      flash[:warning] = 'Invalid credentials, please try again!'
      redirect_to login_path
    end
  end

  def destroy
    session.delete :current_mg_id
    flash[:notice] = 'User successfully logged out'
    redirect_to movies_path
  end
end