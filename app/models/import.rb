class Import < ApplicationRecord
  has_many :import_rows, dependent: destroy
  validates :name, presence: true
end
