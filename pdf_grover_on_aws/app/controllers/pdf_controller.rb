class PdfController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.pdf do
        controller = ActionController::Base.new
        html = controller.render_to_string(template: 'pdf/index', layout: 'pdf')
        pdf = Grover.new(html).to_pdf
        send_data(pdf, filename: 'sample.pdf', type: 'application/pdf')
      end
    end
  end
end