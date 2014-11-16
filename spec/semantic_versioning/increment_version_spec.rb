require 'spec_helper'
require 'open3'

describe "Command 'increment_version' spec" do

  context "Argument '1.2.3'" do

    it "is too short." do
      o,e,s = Open3.capture3('bin/increment_version 1.2.3')
      expect(o).to eq ""
      expect(e).not_to eq ""
      expect(s.exitstatus).to eq 1
    end
  end

  context "Argument 'patch 1.2.3 +build123'" do

    it "is too long." do
      o,e,s = Open3.capture3('bin/increment_version patch 1.2.3 +build123')
      expect(o).to eq ""
      expect(e).not_to eq ""
      expect(s.exitstatus).to eq 1
    end
  end

  context "Increment version '1.2.3'" do

    it "will be returned '2.0.0' when have specified :major label." do
      o,e,s = Open3.capture3('bin/increment_version major 1.2.3')
      expect(o).to eq "2.0.0\n"
      expect(e).to eq ""
      expect(s).to eq 0
    end

    it "will be returned '1.3.0' when have specified :minor label." do
      o,e,s = Open3.capture3('bin/increment_version minor 1.2.3')
      expect(o).to eq "1.3.0\n"
      expect(e).to eq ""
      expect(s.exitstatus).to eq 0
    end

    it "will be returned '1.2.4' when have specified :patch label." do
      o,e,s = Open3.capture3('bin/increment_version patch 1.2.3')
      expect(o).to eq "1.2.4\n"
      expect(e).to eq ""
      expect(s.exitstatus).to eq 0
    end
  end
end
