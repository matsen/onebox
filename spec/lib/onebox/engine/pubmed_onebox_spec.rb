require "spec_helper"

describe Onebox::Engine::PubmedOnebox do

  before(:all) do
    @link = "http://www.ncbi.nlm.nih.gov/pubmed/7288891"
  end

  shared_examples_for "#to_html" do
    it "has the paper's title" do
      expect(html).to include("Evolutionary trees from DNA sequences: a maximum likelihood approach.")
    end

    it "has the paper's author" do
      expect(html).to include("Felsenstein")
    end

    it "has the paper's abstract" do
      expect(html).to include("The application of maximum likelihood techniques to the estimation of evolutionary trees from nucleic acid sequence data is discussed.") end

    it "has the paper's date" do
      expect(html).to include("1981")
    end

    it "has the URL to the resource" do
      expect(html).to include(link)
    end
  end
end
