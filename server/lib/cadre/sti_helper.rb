module Cadre
  module StiHelper
    def self.included(base)
      base.class_eval do
        # define sti_ versions of the url_helpers - these will return the subclass version of the path/url
        [:resource, :edit_resource, :new_resource].each do |named|
          [:path, :url].each do |type|
            define_method "sti_#{named}_#{type}" do |*args|
              send("#{named}_#{type}", *args).sub(resources_name, (args.first || resource).class.name.tableize)
            end
          end
        end
      end
    end
  
    def render_sti_collection(partial, collection, model_controller_mapping = {})
      collection.inject('') do |out, item|
        path = inherited_template_path("#{item.class.name.tableize}/_#{partial}", model_controller_mapping[item.class] || "#{item.class.name.pluralize}Controller".constantize)
        out << render(:file => path, :locals => {partial => item})
      end
    end
  end
end