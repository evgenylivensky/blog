class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :user_id,   null: false
      t.string  :email,     null: false
      t.boolean :published, null: false, default: false
      t.string  :title,     null: false
      t.text    :preview,   null: false, default: '', limit: 1000
      t.text    :body,      null: false, default: ''
      t.integer :comments,  null: false, default: 0

      t.timestamps
    end
  end
end
