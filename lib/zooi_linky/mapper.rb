# todo: brent: separate out into submappers for extensibility

module ZooiLinky
  
  class Mapper
      
    attr_accessor :current_link
    
    def initialize(current_link=nil)
      @current_link = current_link
    end
    
    def self.delegate_to_writer(method, target)
      define_method method do |val|
        obj = self.send target
        obj.send "#{method}=", val
      end
    end
    
    delegate_to_writer :visible_in_menu, :current_link
    delegate_to_writer :title, :current_link
    delegate_to_writer :current_if_selected, :current_link
    delegate_to_writer :options, :current_link
    delegate_to_writer :priority, :current_link
    
    def menu(id, &block)
      link = Menu.new(id, &block)
      Menus[id] = link
    end
    
    def link(id, &block)
      link = Link.new(id, &block)
      # merge options of parent links, entries in new link options take precendence
      link.options.reverse_merge!(current_link.options)
      current_link << link
    end
    
    def url(url)
      current_link.url = LinkUrl.new(url)
    end
    
    def selected_if(clause)
      current_link.add_selection_constraint clause
    end
    
    def selected_if_params(opts)
      selected_if lambda {
        opts.keys.all? { |k| opts[k] == params[k] }
      }
    end
    
    def selected_if_url(url)
      current_link.add_selection_constraint lambda {
        self.current_url == LinkUrl.new(url).resolve(self.view)
      }
    end
    
  end
  
end