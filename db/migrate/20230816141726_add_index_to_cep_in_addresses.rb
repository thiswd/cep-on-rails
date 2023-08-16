class AddIndexToCepInAddresses < ActiveRecord::Migration[7.0]
  def change
    add_index :addresses, :cep
  end
end
