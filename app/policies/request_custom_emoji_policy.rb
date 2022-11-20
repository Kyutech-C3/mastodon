# frozen_string_literal: true

class RequestCustomEmojiPolicy < ApplicationPolicy
  def update?
    admin?
  end

  def destroy?
    admin? || (record.account_id == current_account&.id)
  end
end
