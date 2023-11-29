class PdfController < ApplicationController
  def index
    controller = ActionController::Base.new
    html = controller.render_to_string(template: 'pdf/index', layout: 'pdf')
    pdf = Grover.new(html).to_pdf
    respond_to do |format|
      format.html
      format.pdf do
        send_data(pdf, filename: 'sample.pdf', type: 'application/pdf')
      end
    end
  end
end