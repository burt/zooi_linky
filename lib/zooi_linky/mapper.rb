# todo: brent: separate out into submappers

module ZooiLinky
  
  class Mapper
      
    attr_accessor :current_link
    
    def initialize(current_link=nil)
      @current_link = current_link
    end
    
    def menu(id, &block)
      link = Menu.new(id, &block)
      Menus[id] = link
    end
    
    def link(id, &block)
      link = Link.new(id, &block)
      current_link << link
    end
    
    def title(title)
      current_link.title = title
    end
    
    def url(url)
      current_link.url = url
    end
    
    def selected_if(clause)
      current_link.add_selection_constraint clause
    end
    
  end
  
end