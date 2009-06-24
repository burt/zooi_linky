Autotest.add_hook :initialize do |at|
  at.add_mapping(%r%^test/(\w\/)*\w+_test.*rb$%) { |filename, _|
    filename
  }
end

ActionView::Base.send :include, ZooiLinky::ViewMethods
ActionController::Base.send :include, ZooiLinky::ControllerMethods