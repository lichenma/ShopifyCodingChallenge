class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # DATABASE 
  # - The queries are currently written up for SQLite since this in memory database was chosen to quickly get the project up and running
  # - In the future for the sake of scalability I would definitely want to move it to some form of cloud service (Amazon A3, Microsoft, Google)
  # - SQL/noSQL 


  # MODEL VIEW CONTROLLER 
  # - expand on and style the view for easy form submission 
  # - models and controllers are organized in their respective folders 


  # JSON VALIDATION 
  # - Might want to consider adding this feature as well to verify that the response json is valid 


  # API VERSIONING - SERIALIZATION - PAGINATION (look to add)

  # ADD BULK DELETE 
  # DISCUSS THE N+1 QUERIES ISSUE WITH IMAGE CONTROLLER 
  # LOOK INTO BULK ADD  
  # CLEAN UP 



  # GET /images
  # GET /images.json
  def index
    # TODO: create a service constants class and a function for generating queries 
    visible_flag = "public"
    query = "created_by = \"#{current_user.id}\" OR visibility = \"#{visible_flag}\""
    @images = Image.where(query)
  end

  # GET /images/1
  # GET /images/1.json
  def show
    visible_flag = "public"
    query = "created_by = #{current_user.id} OR visibility = \"#{visible_flag}\""
    # design pattern that you can see public images but you cannot modify or delete them 
    @image = Image.where(query).find(params[:id])
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
    query = "created_by = \"#{current_user.id}\""
    @image = Image.where(query).find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    query = "created_by = \"#{current_user.id}\""
    @image = Image.where(query).find(params[:id])

    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    query = "created_by = \"#{current_user.id}\""
    @image = Image.where(query).find(params[:id])

    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      # honestly this function is not really used as we update @image in the functions
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:title, :created_by, :visibility, :content, :picture).merge(created_by: current_user.id)
    end
end
