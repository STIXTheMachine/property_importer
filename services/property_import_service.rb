class PropertyImportService
  require('csv')

  # import_file: the actual file being imported
  def initialize(import_file)
    @total_rows = 0
    @import_file = import_file
  end

  # Parses a CSV file and saves rows to local storage to allow for validation and editing before sending to db
  def call
    csv = CSV.read(@import_file, headers: true)
    csv.each_with_index do |row, index|
      @total_rows += 1
      import_row = ImportRow.new(row.to_hash)
      import_row.save
    end
  end
end
