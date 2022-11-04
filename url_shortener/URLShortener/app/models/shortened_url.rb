require 'securerandom'
# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
class ShortenedUrl < ApplicationRecord
  validates :long_url, uniqueness: true, presence: true

  def self.random_code
    SecureRandom::urlsafe_base64
  end

  after_initialize do
    need_new_short_url = false

    if self.new_record?
      need_new_short_url = true
    end

    if self.short_url.nil?
      need_new_short_url = true
    end

    if !ShortenedUrl.where("short_url = ?", self.short_url).empty?
      need_new_short_url = true
    end

    self.short_url = generate_short_url if need_new_short_url
  end

  belongs_to :submitter,
  class_name: :User,
  primary_key: :id,
  foreign_key: :user_id

  private
  def generate_short_url
    tmp = ShortenedUrl.random_code
    until ShortenedUrl.where("short_url = ?", tmp).empty?
      tmp = ShortenedUrl.random_code
    end
    tmp
  end
end
