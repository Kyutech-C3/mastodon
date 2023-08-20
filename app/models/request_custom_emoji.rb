# frozen_string_literal: true
# == Schema Information
#
# Table name: request_custom_emojis
#
#  id                           :bigint(8)        not null, primary key
#  state                        :integer          default(0)
#  shortcode                    :string           default(""), not null
#  image_file_name              :string
#  image_content_type           :string
#  image_file_size              :integer
#  image_updated_at             :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  image_storage_schema_version :integer
#  account_id                   :bigint(8)        not null
#

class RequestCustomEmoji < ApplicationRecord
  include Attachmentable

  LIMIT = 50.kilobytes

  SHORTCODE_RE_FRAGMENT = '[a-zA-Z0-9_]{2,}'

  SCAN_RE = /(?<=[^[:alnum:]:]|\n|^)
    :(#{SHORTCODE_RE_FRAGMENT}):
    (?=[^[:alnum:]:]|$)/x

  IMAGE_MIME_TYPES = %w(image/png image/gif).freeze

  belongs_to :account

  has_attached_file :image, styles: { static: { format: 'png', convert_options: '-coalesce -strip' } }, validate_media_type: false

  validates_attachment :image, content_type: { content_type: IMAGE_MIME_TYPES }, presence: true, size: { less_than: LIMIT }
  validates :shortcode, uniqueness: true, format: { with: /\A#{SHORTCODE_RE_FRAGMENT}\z/ }, length: { minimum: 2 }

  scope :alphabetic, -> { order(shortcode: :asc) }

  remotable_attachment :image, LIMIT

  def object_type
    :emoji
  end

  class << self
    def from_text(text, domain = nil)
      return [] if text.blank?

      shortcodes = text.scan(SCAN_RE).map(&:first).uniq

      return [] if shortcodes.empty?

      EntityCache.instance.emoji(shortcodes, domain)
    end

    def search(shortcode)
      where('"custom_emojis"."shortcode" ILIKE ?', "%#{shortcode}%")
    end
  end

  private
end
