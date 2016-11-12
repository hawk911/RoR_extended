class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy if @attachment && current_user.author_of?(@attachment.attachable)
  end
end
