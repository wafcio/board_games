class AuthenticationService
  attr_reader :omniauth

  def initialize(omniauth)
    @omniauth = omniauth
  end

  def find_or_create
    user = find_authentication.try(:user)
    if user
      update_email(user)
      return user
    end

    user = find_email.try(:user)
    if user
      update_authentication(user)
      return user
    end

    create_user
  end

  private

  def find_authentication
    Authentication.find_by(omniauth.slice(:provider, :uid))
  end

  def update_email(user)
    user.emails.create(email: omniauth[:info][:email]) unless find_email
  end

  def find_email
    Email.find_by(email: omniauth[:info][:email])
  end

  def update_authentication(user)
    user.authentications.create(
      provider: omniauth[:provider], uid: omniauth[:uid]
    )
  end

  def create_user
    user = build_user
    user.save
    user
  end

  def build_user
    User.new do |user|
      user.email = omniauth[:info][:email]
      user.password = SecureRandom.hex
      user.password_confirmation = SecureRandom.hex
      user.authentications.build(
        provider: omniauth[:provider], uid: omniauth[:uid]
      )
    end
  end
end
