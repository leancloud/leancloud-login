gem 'omniauth-leancloud', github: 'paomian/omniauth-leancloud'

class LeanCloudAuthenticator < ::Auth::Authenticator

  def name
    'LeanCloud'
  end

  def after_authenticat(auth_token)
    result = Auth::Result.new

    email = auth_token[:email]
    name = auth_token[:username]

    current_info = ::PluginStore.get('leancloud', "leancloud_uid_#{}")

    result.user = 
    if current_info
      User.where(id: current_info[:user_id]).first
    end

    result.name = name
    result.email = email

    result
  end

  def after_create_account(user, auth)
    weibo_uid = auth[:uid]
    ::PluginStore.set('leancloud', "leancloud_id_#{qq_uid}", {user_id: user.id})
  end

  def register_middleware(omniauth)
    omniauth.provide :leancloud, :setup => lambda { |env|
    strategy = env['omniauth.strategy']
    strategy.options[:client_id] = SiteSetting.leancloud_client_id
    strategy.options[:client_secret] = SiteSetting.leancloud_client_secret
    }
  end
end

auth_provider :frame_width => 920,
              :frame_heigth => 800,
              :authenticator => LeanCloudAuthenticator.new,
              :background_color => 'rgb(230,22,45'

register_css << CSS

.btn-social.LeanCloud:before {
  font-family: FontAwesome;
  content: "\\f1d6";
}