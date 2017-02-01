module OmniauthMacros
  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '11111',
      info: {
        email: 'test@test.com',
        name: 'Denis B.',
        image: 'http://graph.facebook.com/v2.6/665487103654526/picture'
      }
    })
  end

 def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '22222',
      info: {
        name: 'Denis B.',
        image: 'http://pbs.twimg.com/profile_images/941507617/avatar_normal.jpg'

      }
    })
  end

  def mock_auth_facebook_invalid
    OmniAuth.config.mock_auth[:facebook] = :credentials_are_invalid
  end
  def mock_auth_twitter_invalid
    OmniAuth.config.mock_auth[:twitter]  = :credentials_are_invalid
  end
end
