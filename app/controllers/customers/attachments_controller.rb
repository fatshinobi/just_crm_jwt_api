class Customers::AttachmentsController < ::AttachmentsController
  private

  def set_parent
    customer_id = params[:customer_id]
    @parent_record = Customer.find(customer_id)
  end

  def to_resource_value
    ClientAttachmentElementResource.new(@attachment)
  end
end
