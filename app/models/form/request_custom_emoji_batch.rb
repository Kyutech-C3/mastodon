# frozen_string_literal: true

class Form::RequestCustomEmojiBatch
  include ActiveModel::Model
  include Authorization
  include AccountableConcern

  attr_accessor :request_custom_emoji_ids, :action, :current_account

  def save
    case action
    when 'approve'
      approve!
    when 'reject'
      reject!
    when 'delete'
      delete!
    end
  end

  private

  def request_custom_emojis
    @request_custom_emojis ||= RequestCustomEmoji.where(id: request_custom_emoji_ids)
  end

  def approve!
    request_custom_emojis.each { |request_custom_emoji| authorize(request_custom_emoji, :update?) }

    request_custom_emojis.each do |request_custom_emoji|
      if request_custom_emoji.state != 0
        next
      end
      request_custom_emoji.update(state: 1)
      new_emoji = CustomEmoji.new(
        shortcode: request_custom_emoji.shortcode,
        image: request_custom_emoji.image
      )
      new_emoji.save
    end
  end

  def reject!
    request_custom_emojis.each { |request_custom_emoji| authorize(request_custom_emoji, :update?) }

    request_custom_emojis.each do |request_custom_emoji|
      if request_custom_emoji.state == 0
        request_custom_emoji.update(state: 2)
      end
    end
  end

  def delete!
    request_custom_emojis.each { |request_custom_emoji| authorize(request_custom_emoji, :destroy?) }

    request_custom_emojis.each do |request_custom_emoji|
      request_custom_emoji.destroy
    end
  end
end
