class User < ActiveRecord::Base
  def self.save_uploaded_file(file, user)
   logger.info "%%%%#{Rails.root}"
    logger.info "userrrrrrrrrrrr #{user.inspect}"
    Dir.mkdir("#{Rails.root}/public/#{user}") if !File.directory?("#{Rails.root}/public/#{user}")
   File.open("#{Rails.root}/public/#{user}/#{user}.txt", "a+") do |f|
     f.write(file.original_filename+ "\n")
   end
   File.open("#{Rails.root}/public/#{user}/#{file.original_filename}", "w+") do |f|
     f.write(file.read)
   end
  end

  def self.check_if_file_exist?(file, user)
    fi = File.read("#{Rails.root}/public/#{user}/#{user}.txt") if File.exist?("#{Rails.root}/public/#{user}/#{user}.txt")
    f = fi.split(/\n/)
    logger.info "fi  ----- #{fi.inspect}      arrrrrrrrrr #{f.inspect} and file --- #{file.inspect}"
    return true if f.include?(file)
    return false
  end 
end
