module AuthHelper
  def http_login
    user = BASIC_AUTH_CONFIG[:username]
    pw = BASIC_AUTH_CONFIG[:password]
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end
