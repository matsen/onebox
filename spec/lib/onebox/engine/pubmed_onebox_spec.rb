require "spec_helper"

describe Onebox::Engine::PubmedOnebox do
  before(:all) do
    @link = "http://www.ncbi.nlm.nih.gov/pubmed/7288891"
  end

  include_context "engines"
  it_behaves_like "an engine"

  describe "#to_html" do
    it "includes pmid" do
      expect(html).to include("7288891")
    end

  end
end
