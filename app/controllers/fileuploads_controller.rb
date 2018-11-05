class FileuploadsController < ApplicationController
  before_action :set_fileupload, only: [:show, :edit, :update, :destroy]
  
  # XHR https://qiita.com/chobi9999/items/2b59fdaf3dd8f2ed9268
  protect_from_forgery :except => [:upload]
  # protect_from_forgery with: :null_session


# Rails Shift_JIS な CSV アップローダを作るときの注意点
# https://blog.kyanny.me/entry/2016/04/06/225749

  def upload
    puts "..in upload"
    render plain: "#{params['file']} is uploded"
    File.open("/home/ubuntu/workspace/hello_app/tmp/#{Time.now.strftime('%Y%m%d%H%M%S')}", "w") { |f|
      # String.force_encoding("UTF-8")
      # f.write(params['file'][0].read.force_encoding('ISO-8859-1'))
      f.write(params['file'][0].read.force_encoding('UTF-8'))
    }
    return false
  end

# params['file'][0] -> #<ActionDispatch::Http::UploadedFile:0x0000000552bb38>
# params['file'][0].class -> ActionDispatch::Http::UploadedFile
# params['file'][0].read -> Encoding::UndefinedConversionError ("\x89" from ASCII-8BIT to UTF-8):
# 


# http://www.ckazu.info/blog/2013/12/04/action_dispatch_http_uploded_file/
# result of params['file'])
# [#<ActionDispatch::Http::UploadedFile:0x0000000552bb38 
#     @tempfile=#<Tempfile:/tmp/RackMultipart20180729-3117-txveak.png>, 
#     @original_filename="line6_deauthorization_pending.png", 
#     @content_type="image/png", 
#     @headers="Content-Disposition: form-data; 
#       name=\"file[]\"; 
#       filename=\"line6_deauthorization_pending.png\"\r\nContent-Type: image/png\r\n">]


  # GET /fileuploads
  # GET /fileuploads.json
  def index
    @fileuploads = Fileupload.all
  end

  # GET /fileuploads/1
  # GET /fileuploads/1.json
  def show
  end

  # GET /fileuploads/new
  def new
    @fileupload = Fileupload.new
  end

  # GET /fileuploads/1/edit
  def edit
  end

  # POST /fileuploads
  # POST /fileuploads.json
  def create
    @fileupload = Fileupload.new(fileupload_params)

    respond_to do |format|
      if @fileupload.save
        format.html { redirect_to @fileupload, notice: 'Fileupload was successfully created.' }
        format.json { render :show, status: :created, location: @fileupload }
      else
        format.html { render :new }
        format.json { render json: @fileupload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fileuploads/1
  # PATCH/PUT /fileuploads/1.json
  def update
    respond_to do |format|
      if @fileupload.update(fileupload_params)
        format.html { redirect_to @fileupload, notice: 'Fileupload was successfully updated.' }
        format.json { render :show, status: :ok, location: @fileupload }
      else
        format.html { render :edit }
        format.json { render json: @fileupload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fileuploads/1
  # DELETE /fileuploads/1.json
  def destroy
    @fileupload.destroy
    respond_to do |format|
      format.html { redirect_to fileuploads_url, notice: 'Fileupload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fileupload
      @fileupload = Fileupload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fileupload_params
      params.require(:fileupload).permit(:name, :filepath, :thumbnail_img_path)
    end
end
