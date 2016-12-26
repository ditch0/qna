class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    sign_in_by_auth(request.env['omniauth.auth'])
  end

  def twitter
    sign_in_by_auth(request.env['omniauth.auth'])
  end

  def proceed_with_email
    email = params.require(:user).fetch(:email)
    auth_hash = OmniAuth::AuthHash.new(
      provider: session[:oauth_provider],
      uid: session[:oauth_uid],
      info: { email: email }
    )
    sign_in_by_auth(auth_hash)
  end

  private

  def sign_in_by_auth(auth_hash)
    @user = User.find_for_oauth(auth_hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name(auth_hash.provider)) if is_navigational_format?
    elsif @user.errors.present?
      session[:oauth_uid] = auth_hash.uid
      session[:oauth_provider] = auth_hash.provider
      render :ask_for_email
    end
  end

  def provider_name(provider)
    providers = {
      facebook: 'Facebook',
      twitter:  'Twitter'
    }
    providers[provider.to_sym]
  end
end
