class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session

  def render_liquid(template_path, locals = {})
    template = Liquid::Template.parse(File.read(Rails.root.join("app", "views", "#{template_path}.liquid")))
    render html: template.render(locals.stringify_keys).html_safe
  end
end
