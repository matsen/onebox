require "spec_helper"

describe Onebox::Engine::ArxivOnebox do

  let(:link) { "http://arxiv.org/abs/hep-ex/0307015" }
  let(:xml_link) { "http://export.arxiv.org/api/query?id_list=hep-ex/0307015" }
  let(:html) { described_class.new(link).to_html }

  before do
    fake(link, response("arxiv"))
    fake(xml_link, response("arxiv-xml"))
  end

  it "has the paper's title" do
    expect(html).to include("Multi-Electron Production at High Transverse Momenta in ep Collisions at HERA")
  end

  it "has the paper's author" do
    expect(html).to include("H1 Collaboration")
  end

  it "has the paper's abstract" do
    expect(html).to include("Multi-electron production is studied at high electron transverse momentum in positron- and electron-proton collisions using the H1 detector at HERA.")
  end

  it "has the paper's date" do
    expect(html).to include("2003-07")
  end

  it "has the URL to the resource" do
    expect(html).to include(link)
  end
end

