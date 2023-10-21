# frozen_string_literal: true

class Settings::RequestCustomEmojisController < Settings::BaseController
  include Authorization

  def index
    @is_admin      = authorize?
    @custom_emojis = RequestCustomEmoji.order(:state, :shortcode).page(params[:page])
    @form          = Form::RequestCustomEmojiBatch.new
  end

  def new
    @custom_emoji = RequestCustomEmoji.new
  end

  def create
    @custom_emoji = RequestCustomEmoji.new(resource_params)
    @custom_emoji.account_id = current_account.id
    if CustomEmoji.find_by(shortcode: @custom_emoji.shortcode, domain: nil)
      @custom_emoji.errors.add(:shortcode, I18n.t('settings.request_custom_emoji.errors.already_exists'))
      render :new
      return
    end

    if @custom_emoji.save
      redirect_to settings_request_custom_emojis_path, notice: I18n.t('settings.request_custom_emoji.created_msg')
    else
      render :new
    end
  end

  def batch
    @form = Form::RequestCustomEmojiBatch.new(form_custom_emoji_batch_params.merge(current_account: current_account, action: action_from_button))
    @form.save
  rescue ActionController::ParameterMissing
    flash[:alert] = I18n.t('admin.accounts.no_account_selected')
  rescue Mastodon::NotPermittedError
    flash[:alert] = I18n.t('admin.custom_emojis.not_permitted')
  ensure
    redirect_to settings_request_custom_emojis_path
  end

  private

  def resource_params
    params.require(:request_custom_emoji).permit(:shortcode, :image)
  end

  def form_custom_emoji_batch_params
  params.require(:form_request_custom_emoji_batch).permit(:action, request_custom_emoji_ids: [])
  end

  def action_from_button
    if params[:approve]
      'approve'
    elsif params[:reject]
      'reject'
    elsif params[:delete]
      'delete'
    end
  end

  def authorize?
    begin
      authorize(:custom_emoji, :index?)
    rescue Mastodon::NotPermittedError
      return false
    end
    return true
  end
end
