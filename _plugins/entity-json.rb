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
        ignore = false
        ['listing', 'search', 'default'].each do |kind|
          if page['layout'] == kind
            ignore = true
          end
        end
        if ignore
          next
        end

        kind = page['layout']
        name = page.url.split("/")[-1]

        if page['layout'] == "car"
          name = page['brand'] + "-" + name
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
        site.pages << JSONPage.new(site, site.source, "/api/", kind+"s.json", JSON.pretty_generate(entries))
      end
    end
  end
end
