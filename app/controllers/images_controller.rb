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


  # BOTTLENECKS 
  # - issue with how the backend image repository is set up is that it uses storage as a way to store the actual images 
  # - how active storage operates behind the scenes is as follows:
  # 
  # - Submitting a form  
  #   - when we submit a form, Rails processes the form, stores the received file on disk, encodes its location as a key 
  #   - it then references that key in the active_storage_blobs table and creates a new record in the images table 
  #   - finally it associates an image with a Blob through active_storage_attachments 
  #
  # - Retrieving an image  
  #   - one get request turns into three: ActiveStorage::BlobsController and ActiveStorage::DiskController are both involved 
  #   - they are all used to serve up the image and the URL will always be decoupled from its actual location 
  #   - If a cloud service is used: BlobsController will redirect to a correct URL located in the cloud 

  # - given that rendering one attachment results in at least three database queries this might be an issue if we are 
  # - sequentially calling lots of requests 
  
  # - for bulk modifications Active Storage provides a solution as it provides a scope with_attached_picture (or whatever the attachment name is)
  # - which includes the associated blobs - we can put this into practice by changing Image.all to Image.with_attached_picture
  

  # BULK ADDITION 
  # - There is a way to implement bulk adding images by associating each image with multiple pictures 
  # - One line change but the user might want to do something else like sequentially create multiple images posts by uploading a ton of images 
  # - this is currentlly not supported in this application 

     
  # TEST DRIVEN DEVELOPMENT AND RSPEC TESTS 
  # - Test Driven Development and just general best practice to include testing as we go through the API development process 
  # - currently a work in progress, I mostly developed this project using unit testing with the generated ERBs 


  # SEARCH/SELL/BUY IMAGES 
  # - Really interested in developing these functionalities (my original intention of the project) but getting the basic crud/user/permissions 
  #   took a bit longer than I would have liked 


  # Queries 
  # - Idea was to make querying functionality so we could filter based on the title, created_by, content 
  # - also wanted to look into Amazon Rekognition so that I could query based on the contents of the image 
  # - use Rekognition so that when a user first makes a POST request we could parse the image and associate it with some keywords which 
  #   can then be used to query the image 


  # Managing Inventory and Sales 
  # - 


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
    @image = Image.find_by(params[:id], created_by: "#{current_user.id}")
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
    @image = Image.find_by(params[:id], created_by: "#{current_user.id}")

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
    @image = Image.find_by(params[:id], created_by: "#{current_user.id}")

    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # DELETE /images/all
  def bulk_destroy
    # This allows us to remove all entries from the table corresponding to our current user 
    @images = Image.where(created_by: "#{current_user.id}")
    @images.destroy_all
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Images belonging to user were successfully destroyed.' }
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
