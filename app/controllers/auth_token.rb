# encoding: utf-8

WalletShark::App.controllers :auth_token do
  
  get :new, :map => '/token/new/?' do
    service_id = params[:service_id]
    service = ServiceProvider.first(:service_id => service_id)
    if service.service_secret != params[:service_secret]
      halt 401
    end
    token = AuthToken.new
    token.service_provider = service
    token.status = :fresh
    token.expire_at = Time.now + 30*60
    token.save
    require 'oj'
    return Oj::dump({token: token.token, status: token.status})
  end

end
