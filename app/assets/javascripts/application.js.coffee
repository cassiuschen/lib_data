# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
# require_tree .
App =
  getWechatSignData: ->
    data = {}
    $.ajax
      type: "GET"
      url: "/wechat/sign?url=#{window.location.href}"
      contentType: "application/json"
      dataType: "json"
      async: false
      success: (result, _) ->
        data = result
    console.log data
    return data
  setupWechat: ->
    data = App.getWechatSignData()
    wx.config
      debug: true
      appId: "wx80262218f360ebe9"
      timestamp: data.timestamp
      nonceStr: 'wx80262218f360ebe9'
      signature: data.signature
      jsApiList: [
        "onMenuShareTimeline",
        "onMenuShareAppMessage"
      ]
window.App = App

$(document).on 'page:change', ->
  window.App.setupWechat()

$ ->
  window.App.setupWechat()