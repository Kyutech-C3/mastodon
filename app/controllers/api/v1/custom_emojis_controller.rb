# frozen_string_literal: true

class Api::V1::CustomEmojisController < Api::BaseController
  skip_before_action :set_cache_headers
  before_action -> { authorize_if_got_token! :write, :'write:custom_emoji' }, only: :create
  before_action -> { doorkeeper_authorize! :write, :'write:custom_emoji' }, only: :create

  def index
    expires_in 3.minutes, public: true
    render_with_cache(each_serializer: REST::CustomEmojiSerializer) { CustomEmoji.listed.includes(:category) }
  end

  def create
    @custom_emoji = CustomEmoji.new(resource_params)

    begin
      @custom_emoji.save!
      render json: @custom_emoji, serializer: REST::CustomEmojiSerializer
    rescue => e
      render json: { error: e }
    end
  end

  private

  def resource_params
    params.permit(:shortcode, :image, :visible_in_picker)
  end

end
