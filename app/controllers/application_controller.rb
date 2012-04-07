class ApplicationController < ActionController::Base
  protect_from_forgery
  include ZonesHelper

  def routing_error
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", status: :not_found }
      format.xml  { head :not_found }
      format.json  { render json: 'Not found', status: :unprocessable_entity }
      format.any  { head :not_found }
    end
    false
  end

  def is_logged
    if session[:user].present? && session[:user]
      true
    else
      redirect_to :signin
      false
    end
  end
end
