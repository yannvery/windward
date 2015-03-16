require 'windward/version'
require 'mechanize'

# Just a naming module
module Windward

  # Instantiate an object to get meteo france previsions
  class Weather

    def initialize
      @departments = load_departments_data
      @cities = load_cities_data
      @regions = load_regions_data
    end

    def regions
      @regions.keys
    end

    def region(name)
      @regions[name]
    end

    def previsions(name)
      @regions[name]['previsions']
    end

    def reload
      @regions = load_data
    end

    def self.root
      File.expand_path('../..', __FILE__)
    end

    private

    def load_departments_data
      load_data_library({ file: 'lib/data/regions.xml', root: 'province', code: 'code', name: 'name_province' })
    end

    def load_cities_data
      load_data_library({ file: 'lib/data/cities.xml', root: 'city', code: 'zip_code', name: 'name' })
    end

    def load_regions_data
      # Get webpage
      page = meteofrance_webpage
      # Store regions data
      data = page.parser.css('div.select-region')
      # Organize rgions data
      regions = parse_regions data
      # Get previsions for each region
      regions.each do |name, values|
        data = page.parser.css("div##{values['value']}")
        previsions = region_previsions data
        regions[name] = regions[name].merge({ 'previsions' => previsions })
      end
      regions
    end

    # Return a hash that contains xml data file content
    def load_data_library(options = { file: nil, root: nil, code: nil, name: nil })
      doc = Nokogiri::XML(open(File.join Weather.root, options[:file]))
      root_elements = doc.root.xpath(options[:root])
      data = Hash.new
      root_elements.each do |p|
        data[p.at_xpath(options[:code]).text] = p.at_xpath(options[:name]).text
      end
      data
    end

    # Get and parse webpage 'www.meteofrance.com/accueil'
    def meteofrance_webpage
      a = Mechanize.new
      page = a.get('http://www.meteofrance.com/accueil')
      page.encoding = 'utf-8'
      page
    end

    # Return a hash for each region like { 'Alsace' => {'slug' => 'alsace', 'value' => 'REGI42' } }
    def parse_regions(data)
      regions = Hash.new
      data.css('option').each do |option|
        if  option['data-type'] == 'REG_FRANCE'
          name = option.content
          slug = option['data-slug']
          value = option['value']
          regions[name] = { 'slug' => slug, 'value' => value }
        end
      end
      regions
    end

    # Complete regions hash with previsions key like :
    # { 'Alsace' =>
    #   { 'slug' => 'alsace', 'value' => 'REGI42',
    #     'previsions' => {'Rhin (Bas)' => {'temps'=>'Éclaircies', 'temper' => '10', 'city' => 'Strasbourg'}}
    #   }
    # }
    def region_previsions(data)
      previsions = Hash.new
      data.each do |datum|
        temps = get_temps datum
        temper = get_temper datum
        department = @departments[datum['data-insee'][0..1]]
        city = @cities[datum['data-insee'][0..4]]
        previsions[department] = { 'temps' => temps, 'temper' => temper, 'city' => city }
      end
      previsions
    end

    def get_temps datum
      content = datum.css('span.picTemps').first.content
      content.split(' - ').last.strip
    end

    def get_temper datum
      content = datum.css('span.temper').first.content
      content.strip
    end
  end
end
