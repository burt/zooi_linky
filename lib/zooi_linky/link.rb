# todo: brent: put constraints into different subclasses, and handle selection logic in mapper

module ZooiLinky
  class Link
    include ActionController::UrlWriter
  
    attr_reader :id
    attr_accessor :title, :url, :parent, :children
    attr_accessor :view, :current_url
      
    def initialize(id, &block)
      @selection_constraints = []
      @children = []
      @id = id
      @title = id
      Mapper.new(self).instance_eval &block if block_given?
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
  
    def url
      case @url
        when Proc then @view.instance_eval &@url
        when Hash then url_for(@url.merge({ :only_path => true }))
        else @url
      end
    end
  
    def selected?
      @selection_constraints.any? { |constraint| constraint.pass?(self) }
    end
  
    def current_url?
      current_url == url
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
      end
    
      unless p.nil?
        @selection_constraints << Constraint.new(p)
      end
    end
  
    # todo: move to subclass of constraint
    def permitted_sym_constraint?(constraint)
      %w{ child_selected? descendant_selected? current_url? }.include? constraint.to_s
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