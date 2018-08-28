class UrlsController < ApplicationController
  before_action :find_url, only: [:redirect_to_original_url, :view]

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    
    if @url.original_url.blank?
      flash[:danger] = 'Cannot be blank'
      redirect_to root_path
    else
      @url.sanitize_url

      if @url.is_new?
        if @url.save
          redirect_to view_path(@url.short_url)
        else
          flash[:danger] = 'Error'
          redirect_to root_path
        end
      else
        flash[:dark] = 'Already exist'
        redirect_to view_path(@url.find_existing_url.short_url)
      end
    end
  end

  def redirect_to_original_url
    redirect_to @url.original_url
  end

  private

  def find_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
