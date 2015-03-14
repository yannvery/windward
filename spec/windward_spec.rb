require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Windward", :vcr => true do
  describe "Weather" do
    it "should get new windward weather" do
      expect(Windward::Weather.new).to_not be_nil
    end
  end
end
