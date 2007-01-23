class ActivationsController < ApplicationController
  # GET /activations
  # GET /activations.xml
  def index
    @activations = Activation.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @activations.to_xml }
    end
  end

  # GET /activations/1
  # GET /activations/1.xml
  def show
    @activation = Activation.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @activation.to_xml }
    end
  end

  # GET /activations/new
  def new
    @activation = Activation.new
    @activation.ip_address = request.remote_ip
  end

  # POST /activations
  # POST /activations.xml
  def create
    @activation = Activation.new(params[:activation])
    @activation.ip_address = request.remote_ip

    respond_to do |format|
      if @activation.save
        flash[:notice] = 'Activation was successfully created.'
        format.html { redirect_to activation_url(@activation) }
        format.xml  { head :created, :location => activation_url(@activation) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activation.errors.to_xml }
      end
    end
  end

  # PUT /activations/1
  # PUT /activations/1.xml
  def update
    @activation = Activation.find(params[:id])
    
    respond_to do |format|
      if @activation.update_attributes(params[:activation])
        flash[:notice] = 'Activation was successfully updated.'
        format.html { redirect_to activation_url(@activation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activation.errors.to_xml }
      end
    end
  end

  # DELETE /activations/1
  # DELETE /activations/1.xml
  def destroy
    @activation = Activation.find(params[:id])
    @activation.destroy

    respond_to do |format|
      format.html { redirect_to activations_url }
      format.xml  { head :ok }
    end
  end
end
