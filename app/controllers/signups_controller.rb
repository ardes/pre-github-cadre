class SignupsController < ApplicationController
  # GET /signups
  # GET /signups.xml
  def index
    @signups = Signup.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @signups.to_xml }
    end
  end

  # GET /signups/1
  # GET /signups/1.xml
  def show
    @signup = Signup.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @signup.to_xml }
    end
  end

  # GET /signups/new
  def new
    @signup = Signup.new
    @signup.ip_address = request.remote_ip
  end

  # POST /signups
  # POST /signups.xml
  def create
    @signup = Signup.new(params[:signup])
    @signup.ip_address = request.remote_ip

    respond_to do |format|
      if @signup.save
        flash[:notice] = 'Signup was successfully created.'
        format.html { redirect_to signup_url(@signup) }
        format.xml  { head :created, :location => signup_url(@signup) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @signup.errors.to_xml }
      end
    end
  end

  # PUT /signups/1
  # PUT /signups/1.xml
  def update
    @signup = Signup.find(params[:id])
    
    respond_to do |format|
      if @signup.update_attributes(params[:signup])
        flash[:notice] = 'Signup was successfully updated.'
        format.html { redirect_to signup_url(@signup) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @signup.errors.to_xml }
      end
    end
  end

  # DELETE /signups/1
  # DELETE /signups/1.xml
  def destroy
    @signup = Signup.find(params[:id])
    @signup.destroy

    respond_to do |format|
      format.html { redirect_to signups_url }
      format.xml  { head :ok }
    end
  end
end
