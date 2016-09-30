class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  protected

  def parse_date_time(params)
    DateTime.new(params[:year].to_i,
                 params[:month].to_i,
                 params[:day].to_i,
                 params[:hour].to_i,
                 params[:minute].to_i)
  end

  def redirect_to_referer
    redirect_to request.referer
  end
end
