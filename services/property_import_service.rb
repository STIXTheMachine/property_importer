# frozen_string_literal: true

class PropertyImportService
  require('csv')

  # model: model to use for CSV row data
  # file: file to import
  def initialize(model, file)
    @model = model
    @file = file
  end

  # Parses a CSV file and saves rows to local storage to allow for validation and editing before sending to db
  def call
    csv = CSV.read(@file, headers: true)

    csv.each_with_index do |row, index|
      # TODO: Make row model
      # TODO: Save each row to local ActiveStorage
      # TODO: add turbo stream broadcast
    end
  end
end
