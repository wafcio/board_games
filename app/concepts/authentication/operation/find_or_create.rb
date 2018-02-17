class Authentication::FindOrCreate < Trailblazer::Operation
  extend Contract::DSL

  step :set_alias_to_auth
  step :find_authentication
  step :optional_update_email
  step :find_email
  step :optional_update_authentication
  step :create_user

  def set_alias_to_auth(ctx)
    ctx[:auth] = ctx['params'][:omniauth]
  end

  def find_authentication(ctx)
    user = Authentication.find_by(authentication_params(ctx)).try(:user)
    ctx[:user] = user if user
    ctx
  end

  def optional_update_email(ctx)
    user = ctx[:user]
    if user
      email = Email.find_by(email_params(ctx))
      return if email

      user.emails.create(email_params(ctx))
      return
    end
    ctx
  end

  def find_email(ctx)
    user = Email.find_by(email_params(ctx)).try(:user)
    ctx[:user] = user if user
    ctx
  end

  def optional_update_authentication(ctx)
    user = ctx[:user]
    if user
      user.authentications.create(authentication_params(ctx))
      return
    end
    ctx
  end

  def create_user(ctx)
    ctx[:step] = 'create_user'
    user = User.new do |user|
      user.email = ctx[:auth][:info][:email]
      user.password = SecureRandom.hex
      user.password_confirmation = user.password
      user.authentications.build(authentication_params(ctx))
    end
    user.save!
    ctx[:user] = user
  end

  private

  def authentication_params(ctx)
    {
      provider: ctx[:auth][:provider],
      uid: ctx[:auth][:uid]
    }
  end

  def email_params(ctx)
    { email: ctx[:auth][:info][:email] }
  end
end
