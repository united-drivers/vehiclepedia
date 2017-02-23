require 'json'

module Jekyll
  class JSONPage < Page
    def initialize(site, base, dir, name, content)
      @site = site
      @base = base
      @dir  = dir
      @name = name

      self.data = {}
      self.content = content

      process(@name)
    end

    def read_yaml(*)
      # Do nothing
    end

    def render_with_liquid?
      false
    end
  end

  class JSONPageGenerator < Generator
    safe true

    def generate(site)
      entities = {}

      dest = site.config["destination"]

      site.pages.each do |page|
        kind = page["url"].split("/")[1]
        name = page.name.split(".")[0]
        if not entities.key?(kind)
          entities[kind] = {}
        end
        output = page.to_liquid
        ['dir', 'layout', 'path', 'url', 'name'].each do |key|
          output.delete(key)
        end
        if output["content"].empty?
          output.delete("content")
        end
        entities[kind][name] = output
      end

      entities.each do |kind, entries|
        site.pages << JSONPage.new(site, site.source, "/", kind+".json", JSON.pretty_generate(entries))
      end
    end
  end
end
