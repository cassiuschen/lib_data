class CreateWechatTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_tokens do |t|
      t.string :content
      t.datetime :timeout
      t.string :ticket
      t.datetime :ticket_timeout

      t.timestamps
    end
  end
end
