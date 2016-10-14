class AddFbIdToPeople < ActiveRecord::Migration
  add_column :people, :fb_id, :string
end
