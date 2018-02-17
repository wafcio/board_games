class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback
    result = Authentication::FindOrCreate.call(omniauth: omniauth)

    if result[:user]
      sign_in_and_redirect result[:user], event: :authentication
      return set_flash_message(:notice, :success, kind: omniauth[:provider])
    end

    failure
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
