class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  # GET /users
  # GET /users.json
  def index
    @current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    if @current_admin and @current_admin.type==1
       @users = User.where(parent_id:@current_admin.id.to_s)
    else
       @users = User.all
    end
    @user_id=params[:pid]
    if  @current_admin
        @user_id=@current_admin.id
    end
 
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end
 
  def toUpdatePassword
     @current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
     if request.post?  
        if params[:newPassword]
          @current_admin.update_attributes!(password_digest: params[:newPassword])
             
        end
        redirect_to "/users?pid="+@current_admin.id, :notice => "已经退出登录"
     end
  end


  def delbinding
     @ud=Userdevice.where(device_id:params[:device_id],user_id:params[:user_id]).first
     if @ud
      @ud.destroy
     end
     respond_to do |format|
         format.json {render :json => {:code =>0}}
     end
  end
  
  def binding
      @ud=Userdevice.new(device_id:params[:device_id],user_id:params[:user_id]);
      @ud.save
      respond_to do |format|
         format.json {render :json => {:code =>0}}
      end
  end

  def devicebinding
    current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    @devices=Device.where(user_id:current_admin.id)
    @bind_id=params[:user_id]
    @user_id=current_admin.id.to_s
    
     
  end
  # GET /users/new
  def new
    @user = User.new
    @user_id=params[:pid]
  end
  
  def logout
     cookies.delete(:token)
     redirect_to root_url, :notice => "已经退出登录"
  end
 
  def login
    cookies.delete(:token)
  end
 
  def register
    if request.get?
       cookies.delete(:token)
    else
      @user = User.new(name: params[:name],password_digest: params[:password],type: 1)
    

      respond_to do |format|
        if @user.save
          @user.update_attributes!(token: SecureRandom.urlsafe_base64)
          format.json {render :json => {:code =>0,:msg =>"注册成功",:redirect_uri =>"/"}}
        else
          format.json {render :json => {:code =>1,:msg =>"注册失败",:redirect_uri =>"/"}}
        end
      end
    end
  end
 
  def create_login_session
    @user = User.find_by_name(params[:name])
    logger.info "OKddddda"
    if @user
      if @user.password_digest==params[:password]
        cookies.permanent[:token] = @user.token
        respond_to do |format|
           format.json {render :json => {:code =>0,:msg =>"登录成功",:redirect_uri =>"/devices/explore?pid="+@user.id}}
        end
      else
        respond_to do |format|
         format.json {render :json => {:code =>1,:msg =>"登录成功",:errorMsg => "密码不对",:redirect_uri =>"/devices/explore?pid="+@user.id}}
        end
        
      end
    else
      respond_to do |format|
         format.json {render :json => {:code =>1,:msg =>"登录成功",:errorMsg => "用户名不存在",:redirect_uri =>"/?pid="+@user.id}}
      end
    end
  end

  # GET /users/1/edit
  def edit
    @current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    @user_id=@current_admin.id
    @user=User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    #@user = User.new(user_params)
    
    current_admin ||=  User.find_by_token(cookies[:token]) if cookies[:token]
    @user = User.new(name:params[:name],parent_id:current_admin.id.to_s,mobile:params[:mobile],email:params[:email],password_digest:params[:password],type:2)
    #@user.save

    respond_to do |format|
      if @user.save
        @user.update_attributes!(token: SecureRandom.urlsafe_base64)
        format.html { redirect_to "/users?pid="+current_admin.id, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    id=params[:id]
    user=User.find(id)
    if user
      password=user.password_digest
      if params[:password]
         password=params[:password]
      end
      user.update_attributes(email:params[:email],mobile:params[:mobile],password_digest:password)
       
    end
    respond_to do |format|
      format.json { render :json => {:code =>0,:msg =>"ok",:redirect_uri =>"/"} }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.json { render :json => {:code =>0,:msg =>"Device was successfully destroyed.",:redirect_uri =>""} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password_digest, :remeber_digest,:type)
    end
end
