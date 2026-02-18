class AddImportIdToImportRow < ActiveRecord::Migration[8.1]
  def change
    add_reference :import_rows, :import, null: false, foreign_key: true
  end
end
