class Attachment < ApplicationRecord
  belongs_to :question
  #belongs_to :answer

  mount_uploader :file, FileUploader
end
