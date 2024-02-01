# frozen_string_literal: true

class DeviseCreateAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :agents do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.datetime :latest_contract_date
      t.integer  :total_contracts, default: 0
      t.integer  :agent_id
      t.string   :rank
      t.string   :role
      t.string   :name
      t.integer  :monthly_dm_target, default: 500
      t.integer  :monthly_appointment_target, default: 10
      t.integer  :monthly_contract_target, default: 4
      t.boolean  :first_login, default: true

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :agents, :email,                unique: true
    add_index :agents, :reset_password_token, unique: true
    # add_index :agents, :confirmation_token,   unique: true
    # add_index :agents, :unlock_token,         unique: true
  end
end
