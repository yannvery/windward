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
      doc = Nokogiri::XML(open(File.join Weather.root, "lib/data/regions.xml"))
      provinces = doc.root.xpath("province")
      departments = Hash.new
      provinces.each do |p|
        departments[p.at_xpath("code").text] = p.at_xpath("name_province").text
      end
      departments
    end

    def cities
      doc = Nokogiri::XML(open(File.join Weather.root, "lib/data/cities.xml"))
      data = doc.root.xpath("city")
      cities = Hash.new
      data.each do |p|
        cities[p.at_xpath("zip_code").text] = p.at_xpath("name").text
      end
      cities
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
