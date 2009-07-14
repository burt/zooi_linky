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
    
    def selected_child_at_depth(depth)
      return self unless depth > 0
      current_link = self
      selected = nil
      while !current_link.nil?
        current_link = current_link.selected_child
        if !current_link.nil? && current_link.depth-1 == depth
          selected = current_link
          break
        end
      end
      selected
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