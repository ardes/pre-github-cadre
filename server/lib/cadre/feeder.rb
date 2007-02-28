module Cadre
  module Feeder
    def self.included(base)
      base.class_eval do
        attr_writer :feed_options, :resources_title
        hide_action :feed_options, :resources_title
      end
    end
    
    def index
      self.resources = find_resources

      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => resources.to_xml }
        format.atom { render_atom_feed_for resources, feed_options }
        format.rss  { render_rss_feed_for resources, feed_options }
      end
    end
  
    def feed_options
      @feed_options ||= { :feed => { :title => resources_title }}
    end
    
    def resources_title
      @resources_title ||= resources_name.titleize + (enclosing_resources.size > 0 ? ' for ' + enclosing_resources.collect(&:name).to_sentence : '')
    end
  end
end