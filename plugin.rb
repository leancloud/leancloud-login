gem 'omniauth-leancloud', '0.1.2'

class LeanCloudAuthenticator < ::Auth::Authenticator

  def name
    'leancloud'
  end

  def after_authenticate(auth_token)
    result = Auth::Result.new
    data = auth_token[:info]
    credentials = auth_token[:credentials]
    email = data[:email]
    name = data[:username]
    raw_info = auth_token[:extra][:raw_info]
    leancloud_uid = auth_token[:uid]
    current_info = ::PluginStore.get('leancloud', "leancloud_uid_#{leancloud_uid}")

    result.user =
      if current_info
        User.where(id: current_info[:user_id]).first
      end

    result.name = name
    result.email = email
    result.extra_data = {leancloud_uid: auth_token[:uid], raw_info: raw_info}
    result
  end

  def after_create_account(user, auth)
    leancloud_uid = auth[:uid]
    ::PluginStore.set('leancloud', "leancloud_uid_#{leancloud_uid}", {user_id: user.id})
  end

  def register_middleware(omniauth)
    omniauth.provider :leancloud, :setup => lambda { |env|
    strategy = env['omniauth.strategy']
    strategy.options[:client_id] = SiteSetting.leancloud_client_id
    strategy.options[:client_secret] = SiteSetting.leancloud_client_secret
    },
    :scope => "client:info"
  end
end

auth_provider :frame_width => 920,
              :frame_heigth => 800,
              :authenticator => LeanCloudAuthenticator.new,
              :background_color => 'rgb(45,135,225)'

register_css <<CSS

.btn-social.LeanCloud:before {
  font-family: FontAwesome;
  content: "\\f1d6";
}

CSS