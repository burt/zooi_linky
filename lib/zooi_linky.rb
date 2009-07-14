module ZooiLinky
  
  def self.map(&block)
    Mapper.new.instance_eval &block
  end
  
end