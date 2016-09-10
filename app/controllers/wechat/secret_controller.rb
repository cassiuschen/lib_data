require 'digest'
class Wechat::SecretController < Wechat::BaseController
  def token
    render text: params[:echostr]
  end

  def jsSDK
    render text: WechatToken.get_token.content
  end

  def sign
    token = "jsapi_ticket=#{WechatToken.get_token.jsTicket}"
    noncestr = "noncestr=#{WechatToken::WECHAT_APP_ID}"
    @time = Time.now.to_i
    timestamp = "timestamp=#{@time}"
    url = "url=#{params[:url]}"

    render json: {
      timestamp: @time,
      signature: "#{Digest::SHA1.hexdigest [token, noncestr, timestamp, url].sort.join("&")}"
    }
  end
end
