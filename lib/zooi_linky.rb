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
      
    def is_current_link?(link)
      !link.nil? && current_link == link
    end
    
  end
  
  module ControllerMethods
    
    def self.included(base)
      [:current_link, :root_link].each { |link| create_helper(base, link) }
    end
    
    def find_current_link
      @current_link = Link.all.find do |l|
        controller_action_id == l.controller_action_id
      end
    end
    
    def find_root_link
      @root_link = @current_link.root unless @current_link.nil?
    end

    def current_url
      self.request.request_uri
    end
    
    def controller_action_id
      {
        :controller => params[:controller],
        :action => params[:action],
        :id => params[:id]
      }
    end
    
    private
    
    # Creates helper methods for given link name
    # E.g. for name 'current_link'
    #   current_link - attr_reader
    #   current_link? - checks whether reader has value
    #   find_current_link - before filter
    def self.create_helper(base, link)
      base.send :define_method, "#{link}?" do
        !(self.send link).nil?
      end
      base.send :helper_method, "#{link}?"
      base.send :attr_reader, link
      base.send :helper_method, link
      base.before_filter "find_#{link}".to_sym
    end
    
  end
  
end