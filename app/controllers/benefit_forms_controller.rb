# frozen_string_literal: true
class BenefitFormsController < ApplicationController

  ALLOWED_FILE_TYPES = { 'pdf' => PdfFile, 'document' => DocumentFile }.freeze

  def index
    @benefits = Benefits.new
  end

  def download
   begin
     path = params[:name]
     file_class = ALLOWED_FILE_TYPES[params[:type]]
     raise ArgumentError, "Invalid file type" unless file_class
     file = file_class.new(path)
     send_file file, disposition: "attachment"
   rescue
     redirect_to user_benefit_forms_path(user_id: current_user.id)
   end
  end

  def upload
    file = params[:benefits][:upload]
    if file
      flash[:success] = "File Successfully Uploaded!"
      Benefits.save(file, params[:benefits][:backup])
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to user_benefit_forms_path(user_id: current_user.id)
  end

end
