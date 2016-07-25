# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'maruku'

  def title(text)
    content_for :title do
      "It's Ripe! - #{text}"
    end
  end

  def hidden
    {:style => 'display:none'}
  end
  def left
    {:style => 'float: left'}
  end
  def right
    {:style => 'float: right'}
  end
  
  def markdown(text)
      text.blank? ? "" : Maruku.new(text).to_html
  end

  def report_to_gsfn
    link_to_function "Report a bug", "show_feedback_widget_for('problem')"
  end
  
  def nav_link_to(title, link, id)
    class_name = @nav_item == id ? "on" : ""
    content_tag("li", link_to(title, link), :class => class_name)
  end
  
  def sub_nav_link_to(title, link, id)
    class_name = @sub_nav_item == id ? "on" : ""
    content_tag("li", link_to(title, link), :class => class_name)
  end
  
  def sort_item(title, id)
    class_name = @sort_by == id ? "on" : ""
    content_tag("dd", link_to(title, "?order=#{id}"), :class => class_name)
  end
  
  def content_header(label, &block)
    content_tag :h1, :class => "content-head clearfix" do
      label
    end
  end
  
  def partial(template, locals={}, &block)
    inner_content = block_given? ? capture(&block) : nil
    
    result = case locals # lets us use a default style when we just need to pass one object
    when Hash
      locals[:inner_content] = inner_content
      render :partial => template, :locals => locals
    else
      render :partial => template, :object => locals
    end
    
    #if a block is given, we concat automatically because of ERB's limitations
    #otherwise, <%= needs to be used
    concat(result, block.binding) if block_given?
    result
  end
  
  def possessive(string)
    if string.ends_with? "s"
      string + "'"
    else 
      string + "'s"
    end
  end
  
  def live_search(locals={})
    render :partial => 'layouts/common/live_search', :locals => locals
  end

  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def iphone_option
    partial 'layouts/common/iphone_option' if iphone_user_agent?
  end
  
  def centered_photo(image_path)
    inside = "<div>#{image_tag image_path, :class => 'photo'}</div>"
    content_tag :div, inside, :class => "photo_wrap"
  end
  
  def ingredient_select(ingredient, size=:small)
    partial "ingredients/ingredient_select", :ingredient => ingredient, :size => size
  end
  
  # Move to constants.rb
  # REVISION_KEY = Svn.new.latest_revision || SimpleGit.head || (Time.now.to_i / 6000).to_s
  # -->
  
  # def versioned_javascript_include_tag(*sources)
  #     options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
  #     
  #     sources.collect do |source|
  #       source = versioned_javascript_path(:version => REVISION_KEY, :action => source)
  # 
  #       
  #       content_tag("script", "", { "type" => "text/javascript", "src" => static_asset_url(source) }.merge(options))
  #     end.join("\n")
  #   end
  #   
  #   def versioned_stylesheet_link_tag(*sources)
  #     options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
  #     sources.collect do |source|
  #       source = versioned_stylesheet_path(:version => REVISION_KEY, :action => source)
  #       tag("link", { "rel" => "Stylesheet", "type" => "text/css", "media" => "screen", "href" =>  static_asset_url(source) }.merge(options))
  #     end.join("\n")
  #   end
  
end
