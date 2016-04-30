class AddDescriptionToEvents < ActiveRecord::Migration
  add_column :events, :description, :text
end
