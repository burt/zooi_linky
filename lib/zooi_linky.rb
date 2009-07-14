# todo: brent: 
# complete 
# - back end menu
# - front end menu
# - permitted to view link helper
# - breadcrumbs (for completeness)
# - setting groups
# - link sets

module ZooiLinky
  
  def self.map(&block)
    Mapper.new.instance_eval &block
  end
  
end