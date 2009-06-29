class Link < ActiveRecord::Base

  serialize :route
  
  attr_reader :url, :route_options
  
  acts_as_tree :order => 'title'
  acts_as_taggable_on :tags
  
  def self.all_except(link)
    conditions = ['id != ?', link.id] unless link.new_record?
    self.all(:conditions => conditions)
  end
  
  def resolved?
    @resolved
  end
  
  def has_children?
    !children.empty?
  end
  
  def self_and_ancestors
    [self] + ancestors
  end
  
  def has_tag?(tag)
    tag_list.include?(tag)
  end
  
  def after_find
    set_route_options
  end
  
  def equivalent?(subject)
    if subject.respond_to? :controller_action_id
      subject.controller_action_id == self.controller_action_id
    else
      false
    end
  end
  
  def controller_action_id
    {
      :controller => route_options[:controller],
      :action => route_options[:action],
      :id => route_options[:id]
    }
  end

  private
  
  # TODO: brent: add in option to pass a symbol
  def set_route_options
    if route.is_a? String
      @url = route
      @route_options = route_for_url(@url)
      @resolved = true unless @route_options.nil?
    else
      @url = url_for(route)
      @route_options = route
      @resolved = true unless @url.nil?
    end
  end
  
  def url_for(opts)
    if url_resolvable_from_opts? opts
      opts.merge!({ :only_path => true })
      UrlWriter.new.send :url_for, opts
    else
      nil
    end
  end
  
  def url_resolvable_from_opts?(opts)
    controller, action, id = opts[:controller], opts[:action], opts[:id]
    return false if controller.nil?
    resolvable = case action.to_sym
      when :show, :edit, :update, :destroy
        !id.nil?
      when :index, :new, :create
        true
      else
        false
    end
  end
  
  def route_for_url(url, method = 'get')
    begin
      ActionController::Routing::Routes.recognize_path(url, :method => method.to_sym)
    rescue
      nil
    end
  end
  
  class UrlWriter
    include ActionController::UrlWriter
  end
  
end