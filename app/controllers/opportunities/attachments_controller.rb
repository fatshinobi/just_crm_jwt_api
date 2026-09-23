class Opportunities::AttachmentsController < ::AttachmentsController
  private

  def set_parent
    opportunity_id = params[:opportunity_id]
    @parent_record = Opportunity.find(opportunity_id)
  end

  def to_resource_value
    ClientAttachmentElementResource.new(@attachment)
  end
end
