module Cadre
  module Feeder
    def self.included(base)
      base.hide_action :feed_options, :feed_options=
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
      @feed_options ||= { :feed => { :title => resources_name.titleize }}
    end

    def feed_options=(options)
      @feed_options = options
    end
  end
end