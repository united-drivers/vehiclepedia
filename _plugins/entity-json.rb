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
        if page["url"] == "/"
          next
        end

        kind = page["url"].split("/")[1]
        if kind == "search.html"
          next
        end
        name = page.name.split(".")[0]
        if name == "index"
          next
        end
        if not entities.key?(kind)
          entities[kind] = {}
        end
        output = page.to_liquid
        ['dir', 'layout', 'path', 'url', 'name'].each do |key|
          output.delete(key)
        end
        output.delete("content")
        entities[kind][name] = output
      end

      entities.each do |kind, entries|
        site.pages << JSONPage.new(site, site.source, "/api/", kind+".json", JSON.pretty_generate(entries))
      end
    end
  end
end
