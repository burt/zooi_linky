module ZooiLinky
  
  class LinkUrl
    include ActionController::UrlWriter
    
    def initialize(url)
      @url = url
    end
    
    def resolve(view)
      case @url
        when Proc then @view.instance_eval &@url
        when Hash then url_for(@url.merge({ :only_path => true }))
        else @url
      end
    end
    
  end
  
end