class AddPersonIdToEvents < ActiveRecord::Migration
  add_reference :events, :person
end
