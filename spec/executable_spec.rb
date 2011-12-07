require "spec_helper"

describe "executable" do

  describe "help" do
    it "should display help message on --help switch" do
      `bundle exec tane` =~ /Usage: tane command \[options\]/
    end
  end

end
