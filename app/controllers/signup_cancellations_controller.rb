class SignupCancellationsController < ApplicationController
  # GET /signup_cancellations
  # GET /signup_cancellations.xml
  def index
    @signup_cancellations = SignupCancellation.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @signup_cancellations.to_xml }
    end
  end

  # GET /signup_cancellations/1
  # GET /signup_cancellations/1.xml
  def show
    @signup_cancellation = SignupCancellation.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @signup_cancellation.to_xml }
    end
  end

  # GET /signup_cancellations/new
  def new
    @signup_cancellation = SignupCancellation.new
    @signup_cancellation.ip_address = request.remote_ip
  end

  # POST /signup_cancellations
  # POST /signup_cancellations.xml
  def create
    @signup_cancellation = SignupCancellation.new(params[:signup_cancellation])
    @signup_cancellation.ip_address = request.remote_ip

    respond_to do |format|
      if @signup_cancellation.save
        flash[:notice] = 'SignupCancellation was successfully created.'
        format.html { redirect_to signup_cancellation_url(@signup_cancellation) }
        format.xml  { head :created, :location => signup_cancellation_url(@signup_cancellation) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @signup_cancellation.errors.to_xml }
      end
    end
  end

  # PUT /signup_cancellations/1
  # PUT /signup_cancellations/1.xml
  def update
    @signup_cancellation = SignupCancellation.find(params[:id])
    
    respond_to do |format|
      if @signup_cancellation.update_attributes(params[:signup_cancellation])
        flash[:notice] = 'SignupCancellation was successfully updated.'
        format.html { redirect_to signup_cancellation_url(@signup_cancellation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @signup_cancellation.errors.to_xml }
      end
    end
  end

  # DELETE /signup_cancellations/1
  # DELETE /signup_cancellations/1.xml
  def destroy
    @signup_cancellation = SignupCancellation.find(params[:id])
    @signup_cancellation.destroy

    respond_to do |format|
      format.html { redirect_to signup_cancellations_url }
      format.xml  { head :ok }
    end
  end
end
