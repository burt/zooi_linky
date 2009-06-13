class Link < ActiveRecord::Base

  serialize :url
  
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
  
  def url
    begin
      path = read_attribute(:url)
      if path.is_a? Symbol
        UrlWriter.new.send path
      else
        path
      end
    rescue
      '/404.html'
    end
  end
  
  private
  
  class UrlWriter
    include ActionController::UrlWriter
  end
  
end