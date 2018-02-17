require 'test_helper'

class Authentication::FindOrCreateTest < ActiveSupport::TestCase
  setup do
    Authentication.delete_all
    Email.delete_all
    User.delete_all
  end

  test 'find user by authentication' do
    create_user
    omniauth = build_omniauth

    result = Authentication::FindOrCreate.call(omniauth: omniauth)
    assert result.failure?
    assert result[:user].present?

    authentications = result[:user].authentications
    providers = authentications.map{ |a| a.provider }
    uids = authentications.map{ |a| a.uid }
    assert authentications.count == 1
    assert providers == ['foo']
    assert uids == ['bar']

    emails = result[:user].emails
    assert emails.size == 1
    assert emails[0].email == 'foo@bar.com'
  end

  test 'find user by authentication and add email when email does not exist' do
    create_user
    omniauth = build_omniauth(email: 'foo2@bar.com')

    result = Authentication::FindOrCreate.call(omniauth: omniauth)
    assert result.failure?
    assert result[:user].present?

    authentications = result[:user].authentications
    providers = authentications.map{ |a| a.provider }
    uids = authentications.map{ |a| a.uid }
    assert authentications.count == 1
    assert providers == ['foo']
    assert uids == ['bar']

    emails = result[:user].emails.map{ |e| e.email }.sort
    assert emails.size == 2
    assert emails == ['foo2@bar.com', 'foo@bar.com']
  end

  test 'find user by email and add authentication' do
    create_user
    omniauth = build_omniauth(uid: 'foo')

    result = Authentication::FindOrCreate.call(omniauth: omniauth)
    assert result.failure?
    assert result[:user].present?

    authentications = result[:user].authentications
    providers = authentications.map{ |a| a.provider }
    uids = authentications.map{ |a| a.uid }
    assert authentications.count == 2
    assert providers == ['foo', 'foo']
    assert uids == ['bar', 'foo']

    emails = result[:user].emails
    assert emails.size == 1
    assert emails[0].email == 'foo@bar.com'
  end

  test 'create user when new user' do
    omniauth = build_omniauth

    result = Authentication::FindOrCreate.call(omniauth: omniauth)
    assert result.success?
    assert result[:user].present?

    authentications = result[:user].authentications
    assert authentications.count == 1
    assert authentications[0].provider == 'foo'
    assert authentications[0].uid == 'bar'

    emails = result[:user].emails
    assert emails.size == 1
    assert emails[0].email == 'foo@bar.com'
  end

  def build_omniauth(uid: 'bar', email: 'foo@bar.com')
    OmniAuth::AuthHash.new(
      provider: :foo,
      uid: uid,
      info: {
        email: email
      }
    )
  end

  def create_user
    user = User.new do |user|
      user.email = 'foo@bar.com'
      user.password = SecureRandom.hex
      user.password_confirmation = user.password
      user.authentications.build(provider: :foo, uid: :bar)
    end
    user.save!
  end
end
