class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback
    @user = AuthenticationService.new(omniauth).find_or_create
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: omniauth[:provider])
  end
  alias_method :facebook, :callback
  alias_method :google_oauth2, :callback
  alias_method :linkedin, :callback

  def failure
    redirect_to root_path
  end

  private

  def omniauth
    request.env['omniauth.auth']
  end
end
