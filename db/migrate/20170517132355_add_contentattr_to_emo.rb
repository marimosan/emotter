class AddContentattrToEmo < ActiveRecord::Migration[5.0]
  def change
    add_column :emos, :content_attr, :string
  end
end
