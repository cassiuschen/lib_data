# == Schema Information
#
# Table name: wechat_tokens
#
#  id             :integer          not null, primary key
#  content        :string
#  timeout        :datetime
#  ticket         :string
#  ticket_timeout :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class WechatToken < ActiveRecord::Base
  WECHAT_TOKEN_API = 'https://api.weixin.qq.com/cgi-bin/token'

  WECHAT_APP_ID = 'wx80262218f360ebe9'
  WECHAT_APP_SECRET = '11335f839481d7fcab49f597017cf542'
  #?grant_type=client_credential&appid=APPID&secret=APPSECRET

  def self.get_token
    if WechatToken.all.size > 0
      if Time.now < WechatToken.all.last.timeout
        @WechatToken = WechatToken.all.last
      else
        @WechatToken = WechatToken.get_new_token
      end
    else
      @WechatToken = WechatToken.get_new_token
    end
    @WechatToken
  end

  def self.get_new_token
    open(WechatToken.generate_api_url) do |http|
      @data = JSON.parse "#{http.read}"
    end
    puts @data
    WechatToken.create_from_api @data
  end

  def jsTicket
    if Time.now >= self.ticket_timeout
      self.generate_js_token
    end
    self.ticket
  end

  def generate_js_token
    open "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{self.content}&type=jsapi" do |http|
      @data = JSON.parse http.read.to_s
    end
    self.ticket = @data["ticket"]
    self.ticket_timeout = Time.now + @data["expires_in"].to_i
    self.save
  end

  def self.create_from_api(data)
    WechatToken.delete_all
    @WechatToken = WechatToken.create(content: data["access_token"], timeout: Time.now + data["expires_in"].to_i)
    @WechatToken.generate_js_token
    @WechatToken
  end

  private
  def self.generate_api_url(appid = WechatToken::WECHAT_APP_ID, appsec = WechatToken::WECHAT_APP_SECRET, grant_type = 'client_credential')
    "#{WechatToken::WECHAT_TOKEN_API}?grant_type=#{ grant_type }&appid=#{ appid }&secret=#{ appsec }"
  end
end
