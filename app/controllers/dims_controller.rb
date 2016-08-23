class DimsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @dims = Dim.all
  end

  def show
    @dim = Dim.find(params[:id])
    @pres = Pre.all
    @focals = Focal.all
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied. this is only for admin"
    end
  end


  def new
    @dim = Dim.new(params[:name])
    @pres = Pre.all
    @AllFocal = Focal.all
  end


  def create
    @dim = Dim.new()
    @dim.name = params[:dim][:name]

    Pre.all.each do |pre|
      if params[pre.id.to_s]
        @dim.pres<<pre
      end
    end
    Focal.all.each do |focal|
      if params["focal"+focal.id.to_s]
        @dim.focals<<focal
      end
    end
    @dim.save
    redirect_to dims_path, :notice => "dimemsion created."
  end


  def update
    @dim = Dim.find(params[:id])
    @allPres = Pre.all
    @dim.pres.delete(@allPres)
    @allPres.each do |pre|
      if params[pre.id.to_s]
        @dim.pres<<pre
      end
    end

    @AllFocals = Focal.all
    @dim.focals.delete(@AllFocals)
    @AllFocals.each do |fo|
      if params["focal"+fo.id.to_s]
        @dim.focals<<fo
      end
    end

    @dim.name = params[:dim][:name]
    @dim.claims = params[:dim][:claims]
    @dim.focalSlot = params[:dim][:focalSlot]
    @dim.proPlDr = params[:dim][:proPlDr]
    @dim.compType = params[:dim][:compType]


    @dim.save

    redirect_to dims_path, :notice => "dimemsion updated."
  end


  def destroy
    dim = Dim.find(params[:id])
    dim.destroy
    redirect_to dims_path, :notice => "Dimemsion deleted."
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
