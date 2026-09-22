class Clients::AttachmentsController < ::AttachmentsController
  private

  def set_parent
    client_id = params[:client_id]
    @parent_record = Client.find(client_id)
  end

  def to_resource_value
    ClientAttachmentElementResource.new(@attachment)
  end
end
