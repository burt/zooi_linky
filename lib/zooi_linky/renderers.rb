module ZooiLinky
  module Renderers
    
    class MenuBuilder

      def build(view, tag)
        original_menu = Menus[tag]
        menu = nil
        unless original_menu.nil?
          menu = original_menu.deep_clone
          assign(menu, { :view => view, :current_url => view.request.request_uri } )
        end
        menu
      end

      def assign(link, props)
        props.each_pair { |k, v| link.send("#{k}=", v) }
        link.children.each { |c| assign(c, props) }
      end

    end
    
    module BasicRenderer
      
      def render_menu(tag)
        menu = MenuBuilder.new.build(self, tag)
        render_link menu
      end
      
      def render_breadcrumbs(tag)
        menu = MenuBuilder.new.build(self, tag)
        menu.breadcrumbs.collect { |l| format_link(l) }.join(" > ")
      end
      
      private
      
      def render_link(menu)
        links = ""
        selected = nil
        unless menu.nil?
          menu.each do |l|
            link_tag = format_link(l)
            li_classes = []
            li_classes << 'current' if l.current_url?
            li_classes << 'selected' if l.selected?
            selected = l if l.selected?
            links << content_tag(:li, link_tag, :class => li_classes.join(' '))
          end
        end
        tags = content_tag :ul, links
        unless selected.nil?
          tags << render_link(selected)
        end
        tags
      end
      
      def format_link(link)
        link_text = link.title.to_s
        link.url.blank? ? link_text : link_to(link_text, link.url)
      end
      
    end
    
  end
end
