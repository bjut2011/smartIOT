class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
    current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    #for de in @devices do
    #    de.update_attributes(user_id:current_admin.id)
      
    #end 
    if current_admin.nil?
        redirect_to root_url, :notice => "已经退出登录"
    end
    name=""
    if params[:name]
       name=params[:name]
    end
    regname = Regexp.new(name)  
    sn=""
    if params[:sn]
       sn=params[:sn]
    end
    regsn = Regexp.new(sn)  
    if params["pid"] and current_admin and current_admin.type ==1
       pid=params["pid"]
       @devices=User.find(pid).device
       @project_name=User.find(pid).name
       @project_id=User.find(pid).id
       @devices=Device.where(:user_id =>pid ,:device_name => regname,:device_sn => regsn)
    end
    if params["pid"] and current_admin and current_admin.type ==2
       @project_name=current_admin.name
       @project_id=current_admin.id.to_s
       @u2ds=Userdevice.where(user_id:current_admin.id.to_s)
       deviceids=[]
       @u2ds.each do |ud|
          deviceids.push(ud.device_id)
       end
       @devices=Device.where(:id.in => deviceids,:device_name => regname,:device_sn => regsn)
    end
    @status=-1
    if params[:status]
     @status=params[:status]
    end
    logger.info "class_1234"
    logger.info @devices.class
  end


  def layout
  end

  def history

   @sensorId=params[:sensorId]
   @deviceId=params[:deviceId]
   @seobject=Sensor.find(@sensorId);
   @deobject=Device.find(@deviceId);
   @queryDate=params[:queryDate]
   logger.info @deobject
   logger.info  @deviceId
  end
  
  def goHistoryLine
   @queryDate=params[:queryDate]
   @sensorid=params[:sensorId]
  end

  def alarmsms
    str='您的验证码是：123。请不要把验证码泄露给其他人。'
    params = {}  
    params["method"] = 'Submit'  
    params["account"] = 'cf_zst'  
    params["password"] = 'cdc123456'  
    params["mobile"] = '13810139056'  
    params["content"] = str  
    uri = URI.parse("http://106.ihuyi.cn/webservice/sms.php?method=Submit")
    res = Net::HTTP.post_form(uri, params) 
    respond_to do |format|
      format.json { render :json => {:code =>1,:msg =>"ok",:redirect_uri =>"/"} }
    end
  end
  
  def queryLineData
    @sensor_id=params[:sensorId]
  end

  def getDevices
    current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    @devices = Device.all
    if params["pid"] and current_admin and current_admin.type==1
       pid=params["pid"]
       logger.info pid
       @devices=User.find(pid).device
       @project_name=User.find(pid).name
       @project_id=User.find(pid).id
    end
    if current_admin and current_admin.type ==2
       @project_name=current_admin.name
       @project_id=current_admin.id.to_s
       @u2ds=Userdevice.where(user_id:current_admin.id.to_s)
       deviceids=[]
       @u2ds.each do |ud|
          deviceids.push(ud.device_id)
       end
       @devices=Device.where(id.in => deviceids)
    end
    respond_to do |format|
      format.json {render :json => {:code =>0,:data => @devices}}
    end
  end

  def explore
    current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    if current_admin.nil?
        redirect_to root_url, :notice => "已经退出登录"
    end
    @devices = Device.all
    if params["pid"] and current_admin and current_admin.type==1
       pid=params["pid"]
       logger.info pid
       @devices=User.find(pid).device
       @project_name=User.find(pid).name
       @project_id=User.find(pid).id
       @user_id=User.find(pid).id
    end
    if current_admin and current_admin.type ==2
       @project_name=current_admin.name
       @user_id=current_admin.id.to_s
       @project_id=current_admin.id.to_s
       @u2ds=Userdevice.where(user_id:current_admin.id.to_s)
       @devices=[]
       @u2ds.each do |ud|
          de=Device.find(ud.device_id)
          if de
            @devices.push(de)
          end
       end
    end
  end
  # GET /devices/1
  # GET /devices/1.json
  def show
      current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
      if current_admin.nil?
        redirect_to root_url, :notice => "已经退出登录"
      end
      @dev_id=params["id"]
      @dev=Device.find(@dev_id)
      if current_admin.type!=0
        @sensor=Sensor.where(:device_id => @dev.id,:display => 1).sort(:order)
        
      else
        @sensor=@dev.sensor
      end
      @project=User.find(@dev.user_id)
  end

  def monitor
   @current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
   if @current_admin.nil?
        redirect_to root_url, :notice => "已经退出登录"
   end
   if params["pid"] and @current_admin and @current_admin.type==1
       pid=params["pid"]
       logger.info pid
       @devices=User.find(pid).device.order('update_time desc')
       @project_name=User.find(pid).name
       @project_id=User.find(pid).id
   else
    
     @devices = Device.all
   end
   if params["pid"] and @current_admin and @current_admin.type ==2
       @project_name=@current_admin.name
       @project_id=@current_admin.id.to_s
       @u2ds=Userdevice.where(user_id:@current_admin.id.to_s)
       @devices=[]
       @u2ds.each do |ud|
          de=Device.find(ud.device_id)
          if de
            @devices.push(de)
          end
       end
       @devices.sort! { |a,b| a.update_time <=> b.update_time }
   end
   @status=-1
   if params[:status]
     @status=params[:status]
   end
  end
  
  def modify
  end
  # GET /devices/new
  def new
    @device = Device.new
    @project_id=params[:pid]
    @current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    if current_admin.nil?
        redirect_to root_url, :notice => "已经退出登录"
    end
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    logger.info params
    create_time=Time.now
    project_id=params["pid"]
    device_name=params["deviceName"]
    device_mark=""
    device_details=""
    sn=params["sn"]
    lon=params["devicePositionLng"].to_f
    lat=params["devicePositionLat"].to_f
    @device = Device.new(user_id:project_id,create_time:create_time,device_name:device_name,device_mark:device_mark,device_details:device_details,lon:lon,lat:lat,device_sn:sn)
    @device.save
    if params[:deviceSensorList]
      for item in params[:deviceSensorList] do
        logger.info item[1][:sensorName]
        senid=item[1][:sensorId]
        sensorType=item[1][:sensorType].to_i
        sensorSign=0
        if item[1][:sensorSign]
           sensorSign=item[1][:sensorSign].to_i 
        end
        if senid!=''
          sen=Sensor.find(senid)
          sen.update_attributes(name:item[1][:sensorName],sensorUnit:item[1][:sensorUnit],sensorType:sensorType,sensorSign:sensorSign)
        else
          sensorType=item[1][:sensorType].to_i
          sensorSign=0
          if item[1][:sensorSign]
            sensorSign=item[1][:sensorSign].to_i 
          end
          sen=Sensor.new(device_id:@device.id,name:item[1][:sensorName],sensorType:sensorType,sensorSign:sensorSign,sensorUnit:item[1][:sensorUnit])
          sen.save()
        end
        
        
     end
    end
    respond_to do |format|
      #if @device.save
        #format.html { redirect_to @device, notice: 'Device was successfully created.' }
        # format.json {render :json => {:code =>0,:msg =>"创建成功",:redirect_uri =>"/",:data => {:device_id => @device.id,:key =>"",:proj_name => @device.project.name}}}
      #else
        #format.html { render :new }
        format.json {render :json => {:code =>1,:msg =>"创建失败",:redirect_uri =>"/devices?pid="+params["pid"]}}
      #end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    @device=Device.find(params[:id])
    deviceName=params[:deviceName]
    sn=params[:sn]
    if deviceName
       @device.update_attributes(device_name:deviceName,device_sn:sn)
    end
    if params[:deviceSensorList]
      for item in params[:deviceSensorList] do
        logger.info item[1][:sensorName]
        senid=item[1][:sensorId]
        sensorType=item[1][:sensorType].to_i
        sensorSign=0
        if item[1][:sensorSign]
           sensorSign=item[1][:sensorSign].to_i 
        end
        if senid!=''
          sen=Sensor.find(senid)
          sen.update_attributes(name:item[1][:sensorName],sensorUnit:item[1][:sensorUnit],sensorType:sensorType,sensorSign:sensorSign)
        else
          sensorType=item[1][:sensorType].to_i
          sensorSign=0
          if item[1][:sensorSign]
            sensorSign=item[1][:sensorSign].to_i 
          end
          sen=Sensor.new(device_id:@device.id,name:item[1][:sensorName],sensorType:sensorType,sensorSign:sensorSign,sensorUnit:item[1][:sensorUnit])
          sen.save()
        end
        
        
      end
    end
    @current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    respond_to do |format|
      format.json { render :json => {:code =>1,:msg =>"ok",:redirect_uri =>"/devices?pid="+@current_admin.id} }
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.json { render :json => {:code =>1,:msg =>"Device was successfully destroyed.",:redirect_uri =>""} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:project_id, :device_name, :device_mark, :device_details, :device_img, :create_time, :lon, :lat)
    end
end
