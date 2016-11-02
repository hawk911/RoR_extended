class AttachmentsController < ApplicationController
  prepend_before_action :authenticate_user!, only: [:destroy]

  def destroy
    @attachment = Attachment.find(params[:id])
    if @attachment && current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash.now[:success] = t('attachments.destroy')
    end
  end
end
