module Spec
  module RouteExpectations
    def self.included(base)
      Hash.class_eval do
        define_method :should_route_to do |path|
          ActionController::Routing::Routes.generate(self).should == path
        end
        include InstanceMethods
      end
      
      String.class_eval do
        define_method :should_route_to do |hash|
          ActionController::Routing::Routes.recognize_path(self).should == hash
        end
        include InstanceMethods
      end
    end
    
    module InstanceMethods
      def should_map_route_with(other)
        self.should_route_to other
        other.should_route_to self
      end
    end
  end
end

    