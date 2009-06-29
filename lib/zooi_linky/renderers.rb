module ZooiLinky
  
  module Renderers
    
    # todo: brent: more work required
    module BasicRenderer
      
      def links_to_tabs(links, selected_class = 'selected')
        list = links.collect do |l|
          if permitted_to_view_link?(l) && l.resolved?
            content_tag :li, anchor_for_link(l), :class => (selected_class if link_selected?(l))
          else
            ''
          end
        end
        content_tag :ul, list
      end
      
      def permitted_to_view_link?(link)
        action_sym = link.route_options[:action].to_sym
        resource_sym = link.route_options[:controller].gsub('/', '_').to_sym
        permitted_to? action_sym, resource_sym
      end

      def link_selected?(link)
        if !is_current_link?(link) && link.has_children?
          link.children.any? { |l| is_current_link?(l) }
        else
          is_current_link?(link)
        end
      end
      
    end
    
  end
  
end