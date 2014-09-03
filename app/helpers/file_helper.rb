module FileHelper
    module ClassMethods
      
      include ImageManipulation
      
      # file_type: file or logo
      def download_file?(file_url, output_file_name, file_type)
       if file_type == "logo"
        download_logo?(file_url, output_file_name) 
       else
        downloaded_file_path = "#{Rails.root}/public/uploads/#{output_file_name}"
        Sync.download_file?(file_url, downloaded_file_path)
        
        downloaded_file_sha1_path = downloaded_file_path + ".sha1"
        Sync.download_file?(file_url + ".sha1", downloaded_file_sha1_path)
        
        check_file_integrity(downloaded_file_path, downloaded_file_sha1_path)
       end
      end

      def upload_object_logo(obj)
        upload_logo(obj, SITE_PORT)
      end
      
      def upload_file(content_upload, port = nil)
        # TODO - would this be easier with request#host_with_port ?
        # Update 2/23/14 - request.ip is returning 127.0.0.1, so we should be really careful and make
        # sure we understand what request.anything will give. We need to be certain this it the
        # app server **IP**
        port = request.port.to_s unless port
        ip_with_port = EOL::Server.ip_address.dup
        ip_with_port += ":" + port unless ip_with_port.match(/:[0-9]+$/)
        parameters = 'function=admin_upload&file_path=http://' + ip_with_port + $CONTENT_UPLOAD_PATH + content_upload.id.to_s + "."  + content_upload.attachment_file_name.split(".")[-1]
        response = EOLWebService.call(parameters: parameters)
        if response.blank?
          ErrorLog.create(url: $WEB_SERVICE_BASE_URL, exception_name: "content upload service failed") if $ERROR_LOGGING
        else
          response = Hash.from_xml(response)
          if response["response"].key? "file_path"
            file_path = response["response"]["file_path"]
            content_upload.update_column(:attachment_cache_url, file_path) # store new url to file on content server
          end
          if response["response"].key? "error"
            error = response["response"]["error"]
            ErrorLog.create(url: $WEB_SERVICE_BASE_URL, exception_name: error, backtrace: parameters) if $ERROR_LOGGING
          end
        end
      end
      
      def delete_file(object, directory_name, file_type)
        old_logo_name = object.logo_file_name
        if old_logo_name
          old_logo_extension = old_logo_name[old_logo_name.rindex(".") + 1, old_logo_name.length]
          if file_type != old_logo_extension
            File.delete("#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{directory_name}_#{object.id}.#{old_logo_extension}") if File.file? "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{directory_name}_#{object.id}.#{old_logo_extension}"
            File.delete("#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{directory_name}_#{object.id}.#{old_logo_extension}.sha1") if File.file? "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{directory_name}_#{object.id}.#{old_logo_extension}.sha1"
          end
        end
      end    
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
