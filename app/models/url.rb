class Url < ApplicationRecord
  validates :original_url, presence: true

  before_create :generate_short_url

  def generate_short_url
    short_url_length = 5
    url_hash = Digest::SHA2.hexdigest(self.original_url)

    while not_uniq?(url_hash[0...short_url_length]) do
      short_url_length += 1
    end

    self.short_url = url_hash[0...short_url_length]

  end

  def not_uniq?(short_url_hash)
    Url.where(short_url: short_url_hash).any?
  end

  def find_existing_url
    Url.where(original_url: self.original_url).first
  end

  def is_new?
    find_existing_url.nil?
  end

  def sanitize_url
    self.original_url.strip!
    sanitized_url = self.original_url.downcase.sub(/(https:\/\/)|(http:\/\/)/, "")
    self.original_url = "http://#{sanitized_url}"
  end
end
