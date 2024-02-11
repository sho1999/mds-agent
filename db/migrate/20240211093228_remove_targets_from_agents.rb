class RemoveTargetsFromAgents < ActiveRecord::Migration[7.1]
  def change
    remove_column :agents, :monthly_dm_target, :integer
    remove_column :agents, :monthly_appointment_target, :integer
    remove_column :agents, :monthly_contract_target, :integer
  end
end
