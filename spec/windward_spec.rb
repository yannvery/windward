require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Windward", :vcr => true do
  describe "Weather" do
    it "should get new windward weather" do
      expect(Windward::Weather.new).to_not be_nil
    end

    it "should returns regions list" do
      weather = Windward::Weather.new
      expect(weather.regions).to include "Alsace"
    end

    it "should return a hash with slug value and previsions of region" do
      weather = Windward::Weather.new
      expect(weather.region "Alsace").to  match a_hash_including("slug", "value", "previsions")
    end

    it "should return a hash that contains a previsions hash of region" do
      weather = Windward::Weather.new
      expect(weather.region("Alsace")["previsions"].values[0]).to  match a_hash_including("temps", "temper", "city")
    end

    it "should return only previsions hash of region" do
      weather = Windward::Weather.new
      expect(weather.previsions("Alsace").values[0]).to  match a_hash_including("temps", "temper", "city")
    end
  end
end
