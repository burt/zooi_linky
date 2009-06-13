module ZooiLinky
  
  module ViewMethods
    def anchor_for_link(link)
      link_to h(link.title), link.url
    end

    def anchor_for_link_unless_current(link, current_link)
      link_to h(link.title), link.url
    end

    def links_with_tag(tag)
      Link.tagged_with(tag, :on => :tags)
    end

    def breadcrumbs_for_link(link)
      link.ancestors.reverse
    end

  end
  
  module ControllerMethods
    
    def self.included(base)
      base.before_filter :find_current_link
      base.before_filter :find_root_link
    end
    
    def find_current_link
      @current_link = Link.all.find { |l| l.url == current_url }
    end
    
    def find_root_link
      @root_link = @current_link.root unless @current_link.nil?
    end

    def current_url
      self.request.request_uri
    end
    
  end
  
end