class HomeController < ApplicationController

  MEGABYTE = 1024.0 * 1024.0
  def index
  end

  def login 
    user_name = params[:user_name]
   if params[:option] == "Login"
#     redirect_to :action => :index if session[user_name].nil? 
#     redirect_to :action => :index if session[user_name] && session[user_name] != password
     @user = user_name
     render :action => :show_page #if session[user_name] == params[:password]
   end
  end

  def show_page
  end

  def get_files
  begin
   @user = params[:data]
   @list_file = File.read("#{Rails.root}/public/#{@user}/#{@user}.txt") if File.exist?("#{Rails.root}/public/#{@user}/#{@user}.txt")
   @lists = @list_file.nil? ? [] : @list_file.split(/\n/)
   @lists = @lists.uniq
   render :partial => 'get_files'
  rescue Exception => err
   @err = err
   render :action => :show_page
  end
  end

  def download
      user_arr = params[:data].split(":")
      file_path = "#{Rails.root}/public/#{user_arr[0]}/#{user_arr[1]}"
      if ((Time.now - File.mtime(file_path))/60).round < 15
        send_file "#{Rails.root}/public/#{user_arr[0]}/#{user_arr[1]}"
      else
        raise ActionController::RoutingError.new(' 404 Not Found')
      end
  end

  def file_upload
   begin 
    size_in_MB = bytes_to_megabytes(params[:file_upload].size)
    raise "Uploaded file should be below 5MB" if size_in_MB > 5
    logger.info "^^^^^^^^^^ #{params[:file_upload].content_type}"
    raise "Only image & pdf files can be uploaded" if !check_for_content_type(params[:file_upload].content_type)
    @user = params[:user]
    store_file = User.save_uploaded_file(params[:file_upload], params[:user])
   rescue Exception => err
     @err = err
   end
   render :action => :show_page
  end

  def bytes_to_megabytes(bytes)
   (bytes/ MEGABYTE).round
  end
 
  def check_for_content_type(content_type)
    return false if !["image/jpeg", "image/png", "image/jpg", "image/gif"].include?(content_type)
    return true
  end
end
