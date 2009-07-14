module ZooiLinky
  
  class Menu < Link
    
    def initialize(id, &block)
      super id, &block
    end
    
    def breadcrumbs
      crumbs = []
      current = @current_link
      until current.nil? || current.root?
        crumbs << current
        current = current.parent
      end
      crumbs.reverse
    end
    
    def current_link
      @current_link ||= find_current(self)
    end
    
    private
    
    def find_current(link)
      return link if link.current_url?
      found = nil
      link.children.each do |c|
        found = find_current c
        break unless found.nil?
      end
      return found
    end
    
  end
end