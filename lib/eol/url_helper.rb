module EOL
  class URLHelper
    # this whole class is pretty hacky, but I couldn't figure out a better way to solve this.
    # we need t way to get URLs for objects when not running the application, like in rake tasks
    # or in certain spec tests. The oly way to achieve that is to have some class include 
    # ActionController::UrlWriter and declare @@default_url_options[:host] . That should not be done
    # outside an object as it will affect the URLs generated by other classes (like in spec tests)
    
    include Rails.application.routes.url_helpers # for using user_url(id) type methods
    Rails.application.routes.default_url_options[:host] = 'eol.org'
    
    def self.get_url(method, id, parameters={})
      # the method needs to be called from an instance - it cannot be called statically
      @@self_reference ||= EOL::URLHelper.new
      return @@self_reference.send(method, id, parameters)
    end
  end
end