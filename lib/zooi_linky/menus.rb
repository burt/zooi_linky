module ZooiLinky
  
  class Menus
    def self.[](key)
      @menu[key] unless @menu.nil?
    end

    def self.[]=(key, value)
      @menu ||= {}
      @menu[key] = value
    end
  end
  
end