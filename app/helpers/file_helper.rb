module FileHelper
    module ClassMethods
      
      include ImageManipulation
      
      def download_file?(file_url, output_file_name, file_type)
        download_logo?(file_url, output_file_name) if file_type == "logo"
      end
      
      def upload_file(obj)
        upload_logo(obj, SITE_PORT)
      end
      
      def delete_file(object, directory_name, file_type)
        old_logo_name = object.logo_file_name
        if old_logo_name
          old_logo_extension = old_logo_name[old_logo_name.rindex(".") + 1, old_logo_name.length]
          if file_type != old_logo_extension
            File.delete("#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{directory_name}_#{object.id}.#{old_logo_extension}") if File.file? "#{Rails.root}/public/#{$LOGO_UPLOAD_PATH}#{directory_name}_#{object.id}.#{old_logo_extension}"
          end
        end
      end    
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
