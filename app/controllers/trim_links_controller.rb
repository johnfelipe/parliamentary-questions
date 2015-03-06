class TrimLinksController < ApplicationController
  before_action :authenticate_user!, PQUserFilter

  def create
    upload = trim_link_params[:file_data]
    if Trim::Validator.valid_upload?(upload)
      io   = upload.read
      trim = TrimLink.create!(data: io,
                              filename: upload.original_filename,
                              size: upload.size,
                              pq_id: trim_link_params[:pq_id])
      link_url  = url_for trim_link_path(trim.id)
      data = success_data('Trim link was successfully created', link_url)
      render json: data, status: 200
    else
      data = failure_data('Missing or invalid trim file!')
      render json: data, status: 400
    end
  end

  def show
    upload = TrimLink.find(params[:id])
    send_data(upload.data, type: 'application/octet-stream',
                           filename: upload.filename,
                           disposition: 'download')
  end

  private

  def failure_data(msg)
    {
      message: msg,
      status: 400
    }
  end

  def success_data(msg, link)
    {
      message: msg,
      link: link,
      status: 200
    }
  end

  def trim_link_params
    params.require(:trim_link).permit(:file_data, :pq_id)
  end
end
