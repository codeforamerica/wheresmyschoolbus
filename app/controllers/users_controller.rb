require 'csv'
class UsersController < ApplicationController
  before_filter :authenticate_admin!, :except => [:splash]
  
  def index
    @users = if params[:q]
      @q = params[:q]
      User.where("email like :q or first_name like :q or last_name like :q",:q=>"%#{params[:q].downcase}%")
    else
      User.all
    end

    respond_to do |format|
      format.html do
        @users = @users.paginate :page=>params[:page]
        render
      end
      format.xml  { render :xml => @users }
      format.csv do
        prefix = @q.present? ? @q.gsub(/\s+/,'_') : "all"
        render_csv(prefix+"_emails.csv") do |csv|
          @users.each {|u| csv << [u.email]}
        end
      end
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @user.busses_attributes = {"0"=>{"fleet_id"=>"none"}} # add a temp new one
    @fleet_ids = $zonar.fleet["assetlist"]["assets"].map {|a| a["fleet"]}
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @fleet_ids = $zonar.fleet["assetlist"]["assets"].map {|a| a["fleet"]}
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_path, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @fleet_ids = $zonar.fleet["assetlist"]["assets"].map {|a| a["fleet"]}
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        @fleet_ids = $zonar.fleet["assetlist"]["assets"].map {|a| a["fleet"]}
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_path, :notice => 'User was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  #get
  def confirm_destroy_all
  end
  
  #delete
  def destroy_all
    User.destroy_all
    respond_to do |format|
      format.html { redirect_to(users_path, :notice => 'All users were successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  private
  def render_csv(filename)
    csv_data = CSV.generate {|csv| yield csv}
    send_data csv_data, :type=> "text/csv", :filename=> filename, :disposition => "attachment"
  end
end
