class PresController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @pres = Pre.all
    @newPre = Pre.new()
  end


  def new
    @dim = Dim.new(params[:name])
    @pres = Pre.all
    @AllFocal = Focal.all
  end


  def create
    @pre = Pre.new()
    @pre.content = params[:pre][:content]
    @pre.save
    redirect_to pres_path, :notice => "Prerequisite created."
  end


  def update
    @pre = Pre.find(params[:id])


    @pre.content = params[:pre][:content]


    @pre.save

    redirect_to pres_path, :notice => "Prerequisite updated."
  end


  def destroy
    pre = Pre.find(params[:id])
    pre.destroy
    redirect_to pres_path, :notice => "Prerequisite deleted."
  end



  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied, This is only for administrators."
    end
  end

  # def secure_params
  #   params.require(:user).permit(:role)
  # end
end
