# todo: brent: put constraints into different subclasses, and handle selection logic in mapper

module ZooiLinky
  class Link
    
    attr_reader :id
    attr_accessor :title, :url, :parent, :children
    attr_accessor :view, :current_url
    attr_accessor :current_if_selected
    attr_accessor :options, :visible_in_menu
      
    def initialize(id, &block)
      @selection_constraints = []
      @options = {}
      @children = []
      @id = id
      @title = id
      @visible_in_menu = true
      Mapper.new(self).instance_eval &block if block_given?
    end
    
    def depth
      d = 0
      current = self
      until current.nil?
        current = current.parent
        d = d + 1
      end
      d
    end
    
    def [](key)
      params[key]
    end

    def []=(key, value)
      params[key] = value
    end
  
    def <<(child)
      @children << child
      child.parent = self
    end
  
    def each()
      @children.each { |c| yield c }
    end
  
    def empty?
      @children.empty?
    end
  
    def has_children?
      !empty?
    end
  
    def root?
      parent.nil?
    end
    
    def title
      if @title.is_a? Proc
        self.instance_eval &@title
      else
        @title
      end
    end
    
    def url
      if @url.respond_to? :resolve
        @url.resolve(@view)
      else
        @url
      end
    end
    
    def route
      begin
        ActionController::Routing::Routes.recognize_path(url.gsub(/\?.*/, ''), :method => :get)
      rescue
        # todo: brent: logging
        {}
      end
    end
  
    def selected?
      @selection_constraints.any? { |constraint| constraint.pass?(self) }
    end
    
    def selected_child
      @children.find { |c| c.selected? }
    end
  
    def current_url?
      if current_if_selected
        selected?
      else
        current_url == url
      end
    end
  
    def child_selected?
      @children.any? { |c| c.selected? }
    end
  
    def descendant_selected?
      @children.any? { |c| c.selected? || c.child_selected? }
    end
  
    def add_selection_constraint(constraint)
      p = if constraint.is_a?(Hash)
        lambda do
          constraint.keys.all? { |k| self[k] == constraint[k] }
        end
      elsif constraint.is_a?(Symbol) && permitted_sym_constraint?(constraint)
        lambda { self.send constraint }
      elsif constraint.is_a?(Proc)
        constraint
      end
    
      unless p.nil?
        @selection_constraints << Constraint.new(p)
      end
    end
  
    # todo: move to subclass of constraint
    def permitted_sym_constraint?(constraint)
      %w{ 
        child_selected?
        descendant_selected?
        current_url?
      }.include? constraint.to_s
    end
  
    def deep_clone
      clone = self.clone
      clone.children = []
      self.children.each { |c| clone << c.deep_clone }
      clone
    end
  
    def params
      @view ? @view.params : {}
    end
  
    class Constraint # todo: different kinds of constraint
    
      def initialize(proc)
        @proc = proc
      end
    
      def pass?(context)
        context.instance_eval &@proc
      end
    
    end
  
  end
  
end