class CreateDb < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.string   :phone_number,   null: false
      t.datetime :deleted_at,     null: true
    end
    add_index :phone_numbers, :deleted_at

    create_table :events do |t|
      t.string     :name,            null: false
      t.string     :broadcast_token, null: false
      t.datetime   :session_expiry,  null: false
      t.integer    :duration,        null: false
      t.belongs_to :user,            null: false
      t.belongs_to :credit,          null: false
      t.belongs_to :phone_number,    null: false
      t.timestamps
    end
    add_index :events, :session_expiry

    create_table :credits do |t|
      t.belongs_to :user,        null: false
      t.belongs_to :coupon,      null: true
      t.belongs_to :purchase, null: true
    end

    create_table :purchases do |t|
      t.integer    :worth,  null: false
      t.belongs_to :user,   null: false
    end

    create_table :coupons do |t|
      t.string   :code,    null: false
      t.integer  :worth,   null: false
    end

    create_table :messages do |t|
      t.text       :body,                     null: false
      t.string     :from,                     null: false
      t.boolean    :selected, default: false, null: false
      t.belongs_to :event,                    null: false
    end
  end
end
