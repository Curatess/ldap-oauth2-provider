class CreateAcmeKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :acme_keys, id: false do |t|
      t.string :token
      t.string :thumbprint
      t.timestamps
    end
    add_index :acme_keys, :token, unique: true
  end
end
