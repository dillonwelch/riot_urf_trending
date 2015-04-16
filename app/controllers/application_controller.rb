class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def champion
    @_champion ||= Champion.find_by_lower_name(params[:name]).first
  end
end
