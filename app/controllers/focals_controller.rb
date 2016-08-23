class FocalsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @focals = Focal.all
    @newFocal = Focal.new()
  end


  def new
    @dim = Dim.new(params[:name])
    @pres = Pre.all
    @AllFocal = Focal.all
  end


  def create
    @focal = Focal.new()
    @focal.content = params[:focal][:content]
    @focal.save
    redirect_to focals_path, :notice => "focal created."
  end


  def update
    @focal = Focal.find(params[:id])


    @focal.content = params[:focal][:content]


    @focal.save

    redirect_to focals_path, :notice => "focal updated."
  end


  def destroy
    focal = Focal.find(params[:id])
    focal.destroy
    redirect_to focals_path, :notice => "focal deleted."
  end



  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied, This is only for administrators."
    end
  end
end
