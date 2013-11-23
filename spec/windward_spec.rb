require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Windward" do
  describe "Weather" do
    it "should get new windward weather" do
      Windward::Weather.new.should_not be_nil
    end
  end
end