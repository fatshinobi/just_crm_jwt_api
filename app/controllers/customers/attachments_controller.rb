class Customers::AttachmentsController < ApplicationController
  def index
    customer_id = params[:customer_id]
    customer = Customer.find(customer_id)
    records = Attachment.where(attachable: customer)
    attachments = ClientAttachmentElementResource.new(records)

    render json: attachments, status: :ok
  end
end
