module ZooiLinky
  module Renderers
    
    module BasicRenderer
      
      def render_menu_level(tag, level, opts = {})
        menu = MenuBuilder.new.build(self, tag)
        link = menu.selected_child_at_depth(level)
        render_link_children(link, opts)
      end
      
      def render_breadcrumbs(tag)
        menu = MenuBuilder.new.build(self, tag)
        menu.breadcrumbs.collect do |l|
          l.current_url? ? l.title : format_link(l)
        end.join(" > ")
      end
      
      private
      
      def render_link_children(link, opts = {})
        links = ""
        unless link.nil?
          link.children.sort.each do |l|
            if visible_in_menu?(l) && permitted_to_view_link?(l)
              link_tag = format_link(l)
              li_classes = []
              li_classes << 'current' if l.current_url?
              li_classes << 'selected' if l.selected?
              selected = l if l.selected?
              links << content_tag(:li, link_tag, :class => li_classes.join(' '))
            end
          end  
        end
        content_tag :ul, links, opts
      end
      
      def format_link(link)
        link_text = link.title.to_s
        link.url.blank? ? link_text : link_to(link_text, link.url)
      end
      
      def visible_in_menu?(link)
        if link.visible_in_menu.is_a? Proc
          self.instance_eval &link.visible_in_menu
        else
          link.visible_in_menu
        end
      end
      
      def permitted_to_view_link?(link)
        action = link.route[:action]
        controller = link.route[:controller]
        if link.options[:model]
          can_list?(link.options[:model].constantize.new)
        elsif (sentry_class = link.options[:sentry])
          can_list?({}, :sentry => sentry_class)
        else
          false
        end
      end
      
    end
    
  end
end
