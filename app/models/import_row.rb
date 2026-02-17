class ImportRow < ApplicationRecord
  belongs_to :import

  before_validation :normalize_fields
  validate :zip_must_be_valid

  validates :building_name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true

  # In pre-validation we normalize to 2 letter state codes
  validates :state, presence: true, inclusion: { in: STATE_CODES }
  validates :zip, presence: true

  private

  # =================================
  # ==== Normalization Functions ====
  # =================================

  def normalize_fields
    normalize_building_name
    normalize_street_address
    normalize_city
    normalize_state
    normalize_zip
  end

  def normalize_building_name
    return if building_name.blank?
    building_name.squish!.upcase!
  end

  def normalize_street_address
    return if street_address.blank?
    street_address.squish!.upcase!
  end

  def normalize_city
    return if city.blank?
    city.squish!.upcase!
  end

  def normalize_state
    return if state.blank?
    # We only alter the value in the model if we can successfully normalize the input string, otherwise we leave it
    # as-is to avoid further corrupting a malformed entry

    # Remove extraneous whitespaces and any periods
    normalized = state.squish.upcase.delete(".")

    if STATE_CODES.include?(normalized)
      # state is already a valid 2 letter state code, we're done
      self.state = normalized
      return
    end

    # Fix up common abbreviations like "N CAROLINA"
    # Don't forget the trailing spaces!!
    if normalized.include?("N ")
      normalized.sub!("N ", "NORTH ")
    elsif normalized.include?("NO ")
      normalized.sub!("NO ", "NORTH ")

    elsif normalized.include?("S ")
      normalized.sub!("S ", "SOUTH ")
    elsif normalized.include?("SO")
      normalized.sub!("SO", "SOUTH ")

    elsif normalized.include?("W ")
      normalized.sub!("W ", "WEST ")
    elsif normalized.include?("WE ")
      normalized.sub!("WE ", "WEST ")
    end

    # Attempt to convert normalized state name to 2 letter state code
    if STATE_NAMES_TO_STATE_CODES.key?(normalized)
      self.state = STATE_NAMES_TO_STATE_CODES[normalized]
    end
  end

  def normalize_zip
    return if zip.blank?
    # Really not much we can do other than trim whitespace and strip the +4 if it's present
    normalized = zip.squish.slice(0, 5)
    zip = normalized
  end

  # ================================
  # ===== Validation Functions =====
  # ================================

  def zip_must_be_valid
    # No real easy way to validate a ZIP code without calling to an external API or maintaining a 45,000 entry list
    # manually, so we only try to filter out the obviously bad ones
    if zip in %w[ 00000, 11111, 12345, 99999 ] or not zip.match(/^\d{5}$/)
      errors.add(:zip, "Invalid Zip Code")
    end
  end
end
