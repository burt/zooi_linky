class Link < ActiveRecord::Base

  serialize :route
  
  attr_reader :url, :route_options
  
  acts_as_tree :order => 'title'
  acts_as_taggable_on :tags
  
  def self.all_except(link)
    conditions = ['id != ?', link.id] unless link.new_record?
    self.all(:conditions => conditions)
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
  
  def controller_action_id
    {
      :controller => route_options[:controller],
      :action => route_options[:action],
      :id => route_options[:id]
    }
  end

  private
  
  def set_route_options
    if route.is_a? String
      @url = route
      @route_options = route_for_url(@url)
    else
      @url = url_for(route)
      @route_options = route
    end
  end
  
  def url_for(opts)
    opts.merge!({ :only_path => true })
    UrlWriter.new.send :url_for, opts
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