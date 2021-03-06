require "#{File.dirname(__FILE__)}/../abstract_unit"

class AssetTagHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  def setup
    silence_warnings do
      ActionView::Helpers::AssetTagHelper.send(
        :const_set,
        :JAVASCRIPTS_DIR,
        File.dirname(__FILE__) + "/../fixtures/public/javascripts"
      )

      ActionView::Helpers::AssetTagHelper.send(
        :const_set,
        :STYLESHEETS_DIR,
        File.dirname(__FILE__) + "/../fixtures/public/stylesheets"
      )

      ActionView::Helpers::AssetTagHelper.send(
        :const_set,
        :ASSETS_DIR,
        File.dirname(__FILE__) + "/../fixtures/public"
      )
    end

    @controller = Class.new do
      attr_accessor :request
      def url_for(*args) "http://www.example.com" end
    end.new

    @request = Class.new do
      def relative_url_root() "" end
    end.new

    @controller.request = @request

    ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
  end

  def teardown
    ActionController::Base.perform_caching = false
    ActionController::Base.asset_host = nil
    ENV["RAILS_ASSET_ID"] = nil
  end

  AutoDiscoveryToTag = {
    %(auto_discovery_link_tag) => %(<link href="http://www.example.com" rel="alternate" title="RSS" type="application/rss+xml" />),
    %(auto_discovery_link_tag(:rss)) => %(<link href="http://www.example.com" rel="alternate" title="RSS" type="application/rss+xml" />),
    %(auto_discovery_link_tag(:atom)) => %(<link href="http://www.example.com" rel="alternate" title="ATOM" type="application/atom+xml" />),
    %(auto_discovery_link_tag(:xml)) => %(<link href="http://www.example.com" rel="alternate" title="XML" type="application/xml" />),
    %(auto_discovery_link_tag(:rss, :action => "feed")) => %(<link href="http://www.example.com" rel="alternate" title="RSS" type="application/rss+xml" />),
    %(auto_discovery_link_tag(:rss, "http://localhost/feed")) => %(<link href="http://localhost/feed" rel="alternate" title="RSS" type="application/rss+xml" />),
    %(auto_discovery_link_tag(:rss, {:action => "feed"}, {:title => "My RSS"})) => %(<link href="http://www.example.com" rel="alternate" title="My RSS" type="application/rss+xml" />),
    %(auto_discovery_link_tag(:rss, {}, {:title => "My RSS"})) => %(<link href="http://www.example.com" rel="alternate" title="My RSS" type="application/rss+xml" />),
    %(auto_discovery_link_tag(nil, {}, {:type => "text/html"})) => %(<link href="http://www.example.com" rel="alternate" title="" type="text/html" />),
    %(auto_discovery_link_tag(nil, {}, {:title => "No stream.. really", :type => "text/html"})) => %(<link href="http://www.example.com" rel="alternate" title="No stream.. really" type="text/html" />),
    %(auto_discovery_link_tag(:rss, {}, {:title => "My RSS", :type => "text/html"})) => %(<link href="http://www.example.com" rel="alternate" title="My RSS" type="text/html" />),
    %(auto_discovery_link_tag(:atom, {}, {:rel => "Not so alternate"})) => %(<link href="http://www.example.com" rel="Not so alternate" title="ATOM" type="application/atom+xml" />),
  }

  JavascriptPathToTag = {
    %(javascript_path("xmlhr")) => %(/javascripts/xmlhr.js),
    %(javascript_path("super/xmlhr")) => %(/javascripts/super/xmlhr.js),
    %(javascript_path("/super/xmlhr.js")) => %(/super/xmlhr.js)
  }

  JavascriptIncludeToTag = {
    %(javascript_include_tag("xmlhr")) => %(<script src="/javascripts/xmlhr.js" type="text/javascript"></script>),
    %(javascript_include_tag("xmlhr.js")) => %(<script src="/javascripts/xmlhr.js" type="text/javascript"></script>),
    %(javascript_include_tag("xmlhr", :lang => "vbscript")) => %(<script lang="vbscript" src="/javascripts/xmlhr.js" type="text/javascript"></script>),
    %(javascript_include_tag("common.javascript", "/elsewhere/cools")) => %(<script src="/javascripts/common.javascript" type="text/javascript"></script>\n<script src="/elsewhere/cools.js" type="text/javascript"></script>),
    %(javascript_include_tag(:defaults)) => %(<script src="/javascripts/prototype.js" type="text/javascript"></script>\n<script src="/javascripts/effects.js" type="text/javascript"></script>\n<script src="/javascripts/dragdrop.js" type="text/javascript"></script>\n<script src="/javascripts/controls.js" type="text/javascript"></script>\n<script src="/javascripts/application.js" type="text/javascript"></script>),
    %(javascript_include_tag(:all)) => %(<script src="/javascripts/application.js" type="text/javascript"></script>\n<script src="/javascripts/bank.js" type="text/javascript"></script>\n<script src="/javascripts/robber.js" type="text/javascript"></script>),
    %(javascript_include_tag(:defaults, "test")) => %(<script src="/javascripts/prototype.js" type="text/javascript"></script>\n<script src="/javascripts/effects.js" type="text/javascript"></script>\n<script src="/javascripts/dragdrop.js" type="text/javascript"></script>\n<script src="/javascripts/controls.js" type="text/javascript"></script>\n<script src="/javascripts/test.js" type="text/javascript"></script>\n<script src="/javascripts/application.js" type="text/javascript"></script>),
    %(javascript_include_tag("test", :defaults)) => %(<script src="/javascripts/test.js" type="text/javascript"></script>\n<script src="/javascripts/prototype.js" type="text/javascript"></script>\n<script src="/javascripts/effects.js" type="text/javascript"></script>\n<script src="/javascripts/dragdrop.js" type="text/javascript"></script>\n<script src="/javascripts/controls.js" type="text/javascript"></script>\n<script src="/javascripts/application.js" type="text/javascript"></script>)
  }

  StylePathToTag = {
    %(stylesheet_path("style")) => %(/stylesheets/style.css),
    %(stylesheet_path("style.css")) => %(/stylesheets/style.css),
    %(stylesheet_path('dir/file')) => %(/stylesheets/dir/file.css),
    %(stylesheet_path('/dir/file.rcss')) => %(/dir/file.rcss)
  }

  StyleLinkToTag = {
    %(stylesheet_link_tag("style")) => %(<link href="/stylesheets/style.css" media="screen" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag("style.css")) => %(<link href="/stylesheets/style.css" media="screen" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag("/dir/file")) => %(<link href="/dir/file.css" media="screen" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag("dir/file")) => %(<link href="/stylesheets/dir/file.css" media="screen" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag("style", :media => "all")) => %(<link href="/stylesheets/style.css" media="all" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag(:all)) => %(<link href="/stylesheets/bank.css" media="screen" rel="Stylesheet" type="text/css" />\n<link href="/stylesheets/robber.css" media="screen" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag(:all, :media => "all")) => %(<link href="/stylesheets/bank.css" media="all" rel="Stylesheet" type="text/css" />\n<link href="/stylesheets/robber.css" media="all" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag("random.styles", "/css/stylish")) => %(<link href="/stylesheets/random.styles" media="screen" rel="Stylesheet" type="text/css" />\n<link href="/css/stylish.css" media="screen" rel="Stylesheet" type="text/css" />),
    %(stylesheet_link_tag("http://www.example.com/styles/style")) => %(<link href="http://www.example.com/styles/style.css" media="screen" rel="Stylesheet" type="text/css" />)
  }

  ImagePathToTag = {
    %(image_path("xml.png")) => %(/images/xml.png),
    %(image_path("dir/xml.png")) => %(/images/dir/xml.png),
    %(image_path("/dir/xml.png")) => %(/dir/xml.png)    
  }

  ImageLinkToTag = {
    %(image_tag("xml.png")) => %(<img alt="Xml" src="/images/xml.png" />),
    %(image_tag("rss.gif", :alt => "rss syndication")) => %(<img alt="rss syndication" src="/images/rss.gif" />),
    %(image_tag("gold.png", :size => "45x70")) => %(<img alt="Gold" height="70" src="/images/gold.png" width="45" />),
    %(image_tag("gold.png", "size" => "45x70")) => %(<img alt="Gold" height="70" src="/images/gold.png" width="45" />),
    %(image_tag("error.png", "size" => "45")) => %(<img alt="Error" src="/images/error.png" />),
    %(image_tag("error.png", "size" => "45 x 70")) => %(<img alt="Error" src="/images/error.png" />),
    %(image_tag("error.png", "size" => "x")) => %(<img alt="Error" src="/images/error.png" />),
    %(image_tag("http://www.rubyonrails.com/images/rails.png")) => %(<img alt="Rails" src="http://www.rubyonrails.com/images/rails.png" />)
  }

  DeprecatedImagePathToTag = {
    %(image_path("xml")) => %(/images/xml.png)
  }


  def test_auto_discovery_link_tag
    AutoDiscoveryToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }
  end

  def test_javascript_path
    JavascriptPathToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }
  end

  def test_javascript_include_tag
    ENV["RAILS_ASSET_ID"] = ""
    JavascriptIncludeToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }

    ENV["RAILS_ASSET_ID"] = "1"
    assert_dom_equal(%(<script src="/javascripts/prototype.js?1" type="text/javascript"></script>\n<script src="/javascripts/effects.js?1" type="text/javascript"></script>\n<script src="/javascripts/dragdrop.js?1" type="text/javascript"></script>\n<script src="/javascripts/controls.js?1" type="text/javascript"></script>\n<script src="/javascripts/application.js?1" type="text/javascript"></script>), javascript_include_tag(:defaults))
  end

  def test_register_javascript_include_default
    ENV["RAILS_ASSET_ID"] = ""
    ActionView::Helpers::AssetTagHelper::register_javascript_include_default 'slider'
    assert_dom_equal  %(<script src="/javascripts/prototype.js" type="text/javascript"></script>\n<script src="/javascripts/effects.js" type="text/javascript"></script>\n<script src="/javascripts/dragdrop.js" type="text/javascript"></script>\n<script src="/javascripts/controls.js" type="text/javascript"></script>\n<script src="/javascripts/slider.js" type="text/javascript"></script>\n<script src="/javascripts/application.js" type="text/javascript"></script>), javascript_include_tag(:defaults)
    ActionView::Helpers::AssetTagHelper::register_javascript_include_default 'lib1', '/elsewhere/blub/lib2'
    assert_dom_equal  %(<script src="/javascripts/prototype.js" type="text/javascript"></script>\n<script src="/javascripts/effects.js" type="text/javascript"></script>\n<script src="/javascripts/dragdrop.js" type="text/javascript"></script>\n<script src="/javascripts/controls.js" type="text/javascript"></script>\n<script src="/javascripts/slider.js" type="text/javascript"></script>\n<script src="/javascripts/lib1.js" type="text/javascript"></script>\n<script src="/elsewhere/blub/lib2.js" type="text/javascript"></script>\n<script src="/javascripts/application.js" type="text/javascript"></script>), javascript_include_tag(:defaults)
  end
  
  def test_stylesheet_path
    StylePathToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }
  end

  def test_stylesheet_link_tag
    ENV["RAILS_ASSET_ID"] = ""
    StyleLinkToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }
  end

  def test_image_path
    ImagePathToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }
  end
  
  def test_image_tag
    ImageLinkToTag.each { |method, tag| assert_dom_equal(tag, eval(method)) }
  end
  
  def test_should_deprecate_image_filename_with_no_extension
    DeprecatedImagePathToTag.each do |method, tag| 
      assert_deprecated("image_path") { assert_dom_equal(tag, eval(method)) }
    end
  end

  def test_timebased_asset_id
    expected_time = File.stat(File.expand_path(File.dirname(__FILE__) + "/../fixtures/public/images/rails.png")).mtime.to_i.to_s
    assert_equal %(<img alt="Rails" src="/images/rails.png?#{expected_time}" />), image_tag("rails.png")
  end

  def test_should_skip_asset_id_on_complete_url
    assert_equal %(<img alt="Rails" src="http://www.example.com/rails.png" />), image_tag("http://www.example.com/rails.png")
  end
  
  def test_should_use_preset_asset_id
    ENV["RAILS_ASSET_ID"] = "4500"
    assert_equal %(<img alt="Rails" src="/images/rails.png?4500" />), image_tag("rails.png")
  end

  def test_preset_empty_asset_id
    ENV["RAILS_ASSET_ID"] = ""
    assert_equal %(<img alt="Rails" src="/images/rails.png" />), image_tag("rails.png")
  end

  def test_should_not_modify_source_string
    source = '/images/rails.png'
    copy = source.dup
    image_tag(source)
    assert_equal copy, source
  end


  def test_caching_javascript_include_tag_when_caching_on
    ENV["RAILS_ASSET_ID"] = ""
    ActionController::Base.asset_host = 'http://a%d.example.com'
    ActionController::Base.perform_caching = true
    
    assert_dom_equal(
      %(<script src="http://a0.example.com/javascripts/all.js" type="text/javascript"></script>),
      javascript_include_tag(:all, :cache => true)
    )

    assert File.exists?(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'all.js'))
    
    assert_dom_equal(
      %(<script src="http://a2.example.com/javascripts/money.js" type="text/javascript"></script>),
      javascript_include_tag(:all, :cache => "money")
    )

    assert File.exists?(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'money.js'))

  ensure
    File.delete(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'all.js'))
    File.delete(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'money.js'))
  end
  
  def test_caching_javascript_include_tag_when_caching_on_and_using_subdirectory
    ENV["RAILS_ASSET_ID"] = ""
    ActionController::Base.asset_host = 'http://a%d.example.com'
    ActionController::Base.perform_caching = true

    assert_dom_equal(
      %(<script src="http://a3.example.com/javascripts/cache/money.js" type="text/javascript"></script>),
      javascript_include_tag(:all, :cache => "cache/money")
    )

    assert File.exists?(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'cache', 'money.js'))
  ensure
    File.delete(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'cache', 'money.js'))
  end
  
  def test_caching_javascript_include_tag_when_caching_off
    ENV["RAILS_ASSET_ID"] = ""
    ActionController::Base.perform_caching = false
    
    assert_dom_equal(
      %(<script src="/javascripts/application.js" type="text/javascript"></script>\n<script src="/javascripts/bank.js" type="text/javascript"></script>\n<script src="/javascripts/robber.js" type="text/javascript"></script>),
      javascript_include_tag(:all, :cache => true)
    )

    assert !File.exists?(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'all.js'))
    
    assert_dom_equal(
      %(<script src="/javascripts/application.js" type="text/javascript"></script>\n<script src="/javascripts/bank.js" type="text/javascript"></script>\n<script src="/javascripts/robber.js" type="text/javascript"></script>),
      javascript_include_tag(:all, :cache => "money")
    )

    assert !File.exists?(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'money.js'))
  end

  def test_caching_stylesheet_link_tag_when_caching_on
    ENV["RAILS_ASSET_ID"] = ""
    ActionController::Base.asset_host = 'http://a%d.example.com'
    ActionController::Base.perform_caching = true
    
    assert_dom_equal(
      %(<link href="http://a3.example.com/stylesheets/all.css" media="screen" rel="Stylesheet" type="text/css" />),
      stylesheet_link_tag(:all, :cache => true)
    )

    assert File.exists?(File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR, 'all.css'))

    assert_dom_equal(
      %(<link href="http://a3.example.com/stylesheets/money.css" media="screen" rel="Stylesheet" type="text/css" />),
      stylesheet_link_tag(:all, :cache => "money")
    )

    assert File.exists?(File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR, 'money.css'))
  ensure
    File.delete(File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR, 'all.css'))
    File.delete(File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR, 'money.css'))
  end
  
  def test_caching_stylesheet_include_tag_when_caching_off
    ENV["RAILS_ASSET_ID"] = ""
    ActionController::Base.perform_caching = false
    
    assert_dom_equal(
      %(<link href="/stylesheets/bank.css" media="screen" rel="Stylesheet" type="text/css" />\n<link href="/stylesheets/robber.css" media="screen" rel="Stylesheet" type="text/css" />),
      stylesheet_link_tag(:all, :cache => true)
    )

    assert !File.exists?(File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR, 'all.css'))
    
    assert_dom_equal(
      %(<link href="/stylesheets/bank.css" media="screen" rel="Stylesheet" type="text/css" />\n<link href="/stylesheets/robber.css" media="screen" rel="Stylesheet" type="text/css" />),
      stylesheet_link_tag(:all, :cache => "money")
    )

    assert !File.exists?(File.join(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR, 'money.css'))
  end
end

class AssetTagHelperNonVhostTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  def setup
    @controller = Class.new do
      attr_accessor :request

      def url_for(options, *parameters_for_method_reference)
        "http://www.example.com/collaboration/hieraki"
      end
    end.new
    
    @request = Class.new do 
      def relative_url_root
        "/collaboration/hieraki"
      end

      def protocol
        'gopher://'
      end
    end.new
    
    @controller.request = @request
    
    ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
  end

  def test_should_compute_proper_path
    assert_dom_equal(%(<link href="http://www.example.com/collaboration/hieraki" rel="alternate" title="RSS" type="application/rss+xml" />), auto_discovery_link_tag)
    assert_dom_equal(%(/collaboration/hieraki/javascripts/xmlhr.js), javascript_path("xmlhr"))
    assert_dom_equal(%(/collaboration/hieraki/stylesheets/style.css), stylesheet_path("style"))
    assert_dom_equal(%(/collaboration/hieraki/images/xml.png), image_path("xml.png"))
  end
  
  def test_should_ignore_relative_root_path_on_complete_url
    assert_dom_equal(%(http://www.example.com/images/xml.png), image_path("http://www.example.com/images/xml.png"))
  end

  def test_should_compute_proper_path_with_asset_host
    ActionController::Base.asset_host = "http://assets.example.com"
    assert_dom_equal(%(<link href="http://www.example.com/collaboration/hieraki" rel="alternate" title="RSS" type="application/rss+xml" />), auto_discovery_link_tag)
    assert_dom_equal(%(http://assets.example.com/collaboration/hieraki/javascripts/xmlhr.js), javascript_path("xmlhr"))
    assert_dom_equal(%(http://assets.example.com/collaboration/hieraki/stylesheets/style.css), stylesheet_path("style"))
    assert_dom_equal(%(http://assets.example.com/collaboration/hieraki/images/xml.png), image_path("xml.png"))
  ensure
    ActionController::Base.asset_host = ""
  end

  def test_should_ignore_asset_host_on_complete_url
    ActionController::Base.asset_host = "http://assets.example.com"
    assert_dom_equal(%(<link href="http://bar.example.com/stylesheets/style.css" media="screen" rel="Stylesheet" type="text/css" />), stylesheet_link_tag("http://bar.example.com/stylesheets/style.css"))
  ensure
    ActionController::Base.asset_host = ""
  end

  def test_should_wildcard_asset_host_between_zero_and_four
    ActionController::Base.asset_host = 'http://a%d.example.com'
    assert_match %r(http://a[0123].example.com/collaboration/hieraki/images/xml.png), image_path('xml.png')
  ensure
    ActionController::Base.asset_host = nil
  end

  def test_asset_host_without_protocol_should_use_request_protocol
    ActionController::Base.asset_host = 'a.example.com'
    assert_equal 'gopher://a.example.com/collaboration/hieraki/images/xml.png', image_path('xml.png')
  ensure
    ActionController::Base.asset_host = nil
  end
end
