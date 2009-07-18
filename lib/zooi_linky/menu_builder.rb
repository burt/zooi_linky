module ZooiLinky    
   class MenuBuilder

    def build(view, tag)
      original_menu = Menus[tag]
      menu = nil
      current_url = view.request.request_uri.gsub /\?.*/, ''
      unless original_menu.nil?
        menu = original_menu.deep_clone
        assign(menu, { :view => view, :current_url => current_url } )
      end
      menu
    end

    def assign(link, props)
      props.each_pair { |k, v| link.send("#{k}=", v) }
      link.children.each { |c| assign(c, props) }
    end
    
  end
end