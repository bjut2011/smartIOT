class SensorlogsController < ApplicationController
  before_action :set_sensorlog, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  # GET /sensorlogs
  # GET /sensorlogs.json
  def index
    @sensorlogs = Sensorlog.all
  end

  # GET /sensorlogs/1
  # GET /sensorlogs/1.json
  def show
  end

  # GET /sensorlogs/new
  def new
    @sensorlog = Sensorlog.new
  end

  # GET /sensorlogs/1/edit
  def edit
  end
 
  def GetDevicesHistory
    sdate=DateTime.parse(params[:Start])
    edate=DateTime.parse(params[:End])
    stime = Time.new(sdate.year,sdate.month,sdate.mday,sdate.hour,sdate.min)
    etime = Time.new(edate.year,edate.month,edate.mday,edate.hour,edate.min)
    dstime=stime.to_f
    detime=etime.to_f
    @slog=Sensorlog.where(:device_id => params[:DeviceID],:createtime.gt => dstime,:createtime.lt => detime).limit(500)
    if @slog and @slog.size>0
      @lastDeviceUtcDate=Sensorlog.where(:device_id => params[:DeviceID],:createtime.gt => dstime,:createtime.lt => detime).limit(500).last.deviceUtcDate
    end
    logger.info params[:DeviceID]
    respond_to do |format|
      format.json {render :json => {:code =>0,:d => {:devices => @slog,:lastDeviceUtcDate => @lastDeviceUtcDate}}}
    end

  end 
  def getData
    @sensorlog=Sensorlog.where(sensor_id:params[:sensorid]).limit(12)
    logger.info params
    respond_to do |format|
      format.json {render :json => {:code =>0,:data => @sensorlog}}
    end
  end

  # POST /sensorlogs
  # POST /sensorlogs.json
  def create
    @sensorlog = Sensorlog.new(sensorlog_params)

    respond_to do |format|
      if @sensorlog.save
        format.html { redirect_to @sensorlog, notice: 'Sensorlog was successfully created.' }
        format.json { render :show, status: :created, location: @sensorlog }
      else
        format.html { render :new }
        format.json { render json: @sensorlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sensorlogs/1
  # PATCH/PUT /sensorlogs/1.json
  def update
    respond_to do |format|
      if @sensorlog.update(sensorlog_params)
        format.html { redirect_to @sensorlog, notice: 'Sensorlog was successfully updated.' }
        format.json { render :show, status: :ok, location: @sensorlog }
      else
        format.html { render :edit }
        format.json { render json: @sensorlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensorlogs/1
  # DELETE /sensorlogs/1.json
  def destroy
    @sensorlog.destroy
    respond_to do |format|
      format.html { redirect_to sensorlogs_url, notice: 'Sensorlog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensorlog
      @sensorlog = Sensorlog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensorlog_params
      params.require(:sensorlog).permit(:value)
    end
end
