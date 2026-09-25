class Appointments::AttachmentsController < ::AttachmentsController
  private

  def set_parent
    appointment_id = params[:appointment_id]
    @parent_record = Appointment.find(appointment_id)
  end

  def to_resource_value
    ClientAttachmentElementResource.new(@attachment)
  end
end
