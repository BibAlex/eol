require 'digest'
module ImageManipulation

  def upload_logo(obj, port = nil)
    port = request.port.to_s unless port
    if file_path = ContentServer.upload_content($LOGO_UPLOAD_PATH + ImageManipulation.local_file_name(obj), port)
      obj.update_attributes(:logo_cache_url => file_path) # store new url to logo on content server
    end
  end

  # TODO - this naming logic does not belong here. ...is it possible to get this from paperclip?  Seems that module knows about it. If not, we should move
  # it to a module that we include when we include paperclip... but it sure smells like it belongs with paperclip...
  def self.local_file_name(obj)
    obj.class.table_name + "_" + obj.id.to_s + "."  + obj.logo_file_name.split(".")[-1]
  end
  
  def download_logo?(file_url, output_file_name)
    downloaded_logo_path = "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{output_file_name}"
    Sync.download_file?(file_url, downloaded_logo_path)
    
    downloaded_logo_sha1_path = downloaded_logo_path + ".sha1"
    Sync.download_file?(file_url + ".sha1", downloaded_logo_sha1_path)
    
    check_file_integrity(downloaded_logo_path, downloaded_logo_sha1_path)
  end
  
  private 
  
  def check_file_integrity(file_path, file_sha1_path)
    if File.file? file_path
      original_sh1 = read_file(file_sha1_path)
      current_sha1 = generate_sha1(file_path)
      return original_sh1 == current_sha1
    end
  end
  
  def read_file(file_path)
    file = File.open(file_path, "rb")
    content = file.read
    file.close
    return content
  end
  
  def generate_sha1(local_file_url)
    sha1 = Digest::SHA1.new
    File.open(local_file_url) do |file|
      buffer = ''
      while not file.eof
        file.read(512, buffer)
        sha1.update(buffer)
      end
    end
    return sha1.to_s
  end
end
