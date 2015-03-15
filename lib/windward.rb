require "windward/version"
require 'mechanize'

module Windward

  class Weather

    def initialize
      @departments = departments
      @cities = cities
      @regions = load_data
    end

    def regions
      @regions.keys
    end

    def region(name)
      @regions[name]
    end

    def previsions(name)
      @regions[name]["previsions"]
    end

    def reload
      @regions = load_data
    end

    def self.root
      File.expand_path('../..', __FILE__)
    end

    private

    def departments
      load_data_library({ file: "lib/data/regions.xml", root: "province", code: "code", name: "name_province" })
    end

    def cities
      load_data_library({ file: "lib/data/cities.xml", root: "city", code: "zip_code", name: "name" })
    end

    def load_data_library options={ file: nil, root: nil, code: nil, name: nil }
      doc = Nokogiri::XML(open(File.join Weather.root, options[:file]))
      root_elements = doc.root.xpath(options[:root])
      data = Hash.new
      root_elements.each do |p|
        data[p.at_xpath(options[:code]).text] = p.at_xpath(options[:name]).text
      end
      data
    end

    def load_data
      a = Mechanize.new
      page = a.get('http://www.meteofrance.com/accueil')
      page.encoding = 'utf-8'
      data  = page.parser.css("div.select-region")
      regions = Hash.new
      data.css("option").each do |option|
        if  option['data-type'] == "REG_FRANCE"
          name = option.content
          slug = option['data-slug']
          value = option['value']
          regions[name] = { "slug" => slug, "value" => value }
        end
      end
      regions.each do |name, values|
        data = page.parser.css("div##{values['value']}")
        previsions = Hash.new
        data.each do |datum|
          temps = datum.css('span.picTemps').first.content.split(' - ').last.strip
          temper = datum.css('span.temper').first.content.strip
          department = @departments[datum['data-insee'][0..1]]
          city = @cities[datum['data-insee'][0..4]]
          previsions[department] = { "temps" => temps, "temper" => temper, "city" => city }
        end
        regions[name] = regions[name].merge({ "previsions" => previsions })
      end
      regions
    end

  end

end
