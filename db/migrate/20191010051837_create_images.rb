class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :title
      t.string :created_by
      t.belongs_to :user, foreign_key: true
      t.string :visibility
      t.text :content

      t.timestamps
    end
  end
end
