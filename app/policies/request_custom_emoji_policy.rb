# frozen_string_literal: true

class RequestCustomEmojiPolicy < ApplicationPolicy
  def update?
    role.can?(:manage_custom_emojis)
  end

  def destroy?
    role.can?(:manage_custom_emojis) || (record.account_id == current_account&.id)
  end
end
