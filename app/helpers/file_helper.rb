module FileHelper
    module ClassMethods
      
      include ImageManipulation
      
      def download_file?(file_url, output_file_name, file_type)
        download_logo?(file_url, output_file_name) if file_type == "logo"
      end
      
      def upload_file(obj)
        upload_logo(obj, SITE_PORT)
      end
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
