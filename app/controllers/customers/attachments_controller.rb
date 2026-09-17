class Customers::AttachmentsController < ApplicationController
  before_action :set_customer, only: [ :index, :create ]

  def index
    records = Attachment.where(attachable: @customer)
    attachments = ClientAttachmentElementResource.new(records)

    render json: attachments, status: :ok
  end

  def create
    attachment = Attachment.new(attachable: @customer, description: params[:description], uploaded_file: params[:uploaded_file], attachment_type: define_attachment_type)

    if attachment.save
      render json: { message: "Attachment created successfully" }, status: :created
    else
      render json: { errors: attachment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    attachment = Attachment.find(params[:id])

    if attachment.update(description: params[:description])
      render json: { message: "Attachment updated successfully" }, status: :ok
    else
      render json: { errors: attachment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    attachment_rec = Attachment.find(params[:id])
    attachment = ClientAttachmentElementResource.new(attachment_rec)
    render json: attachment, status: :ok
  end

  private

  def set_customer
    customer_id = params[:customer_id]
    @customer = Customer.find(customer_id)
  end

  def define_attachment_type
    content_type = params["uploaded_file"]&.content_type
    return 0 unless content_type

    case content_type
    when "image/jpeg", "image/png", "image/gif"
      1
    when "application/pdf"
      3
    when "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      2
    when "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      2
    else
      0
    end
  end
end
