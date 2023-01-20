class RtaxiconnectsController < ApplicationController
  before_action :set_rtaxiconnect, only: %i[ show edit update destroy ]

  # GET /rtaxiconnects or /rtaxiconnects.json
  def index
    @rtaxiconnects = Rtaxiconnect.all
  end

  # GET /rtaxiconnects/1 or /rtaxiconnects/1.json
  def show
  end

  # GET /rtaxiconnects/new
  def new
    @rtaxiconnect = Rtaxiconnect.new
  end

  # GET /rtaxiconnects/1/edit
  def edit
  end

  # POST /rtaxiconnects or /rtaxiconnects.json
  def create
    @rtaxiconnect = Rtaxiconnect.new(rtaxiconnect_params)

    respond_to do |format|
      if @rtaxiconnect.save
        format.html { redirect_to rtaxiconnect_url(@rtaxiconnect), notice: "Rtaxiconnect was successfully created." }
        format.json { render :show, status: :created, location: @rtaxiconnect }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rtaxiconnect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rtaxiconnects/1 or /rtaxiconnects/1.json
  def update
    respond_to do |format|
      if @rtaxiconnect.update(rtaxiconnect_params)
        format.html { redirect_to rtaxiconnect_url(@rtaxiconnect), notice: "Rtaxiconnect was successfully updated." }
        format.json { render :show, status: :ok, location: @rtaxiconnect }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rtaxiconnect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rtaxiconnects/1 or /rtaxiconnects/1.json
  def destroy
    @rtaxiconnect.destroy

    respond_to do |format|
      format.html { redirect_to rtaxiconnects_url, notice: "Rtaxiconnect was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rtaxiconnect
      @rtaxiconnect = Rtaxiconnect.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rtaxiconnect_params
      params.require(:rtaxiconnect).permit(:to, :from)
    end
end
