class BandsController < ApplicationController
  # Do allow unlogged in users to browse bands.
  before_action :require_user!, only: [:new, :create, :edit, :update]

  def index
    @bands = Band.all
    render :index
  end

  def show
    @band = Band.find(params[:id])
    render :show
  end

  def new
    @band = Band.new
    render :new
  end

  def create
    @band = current_user.bands.new(band_params)
    if @band.save
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :new
    end
  end

  def edit
    @band = current_user.bands.find(params[:id])
    render :edit
  end

  def update
    @band = current_user.bands.find(params[:id])
    if @band.update_attributes(band_params)
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :edit
    end
  end

  private

  def band_params
    params.require(:band).permit(:name)
  end
end
