module Onebox
  module Engine
    class PubmedOnebox
      include Engine
      include LayoutSupport

      matches do
        http
        maybe("www.")
        domain("ncbi.nlm.nih")
        tld("gov")
        has("/pubmed/")
      end

      private

      def data
        doc = Nokogiri::XML(open(@url + "?report=xml&format=text"))
        pre = doc.xpath('//pre')
        xml = "<root>" + pre.text + "</root>"
        contents = Nokogiri::XML(xml)
        {
         title: contents.css('ArticleTitle')[0].content,
         authors: (contents.css('LastName').map{|x| x.content}).join(", "),
         journal: contents.css('Title')[0].content,
         abstract: contents.css('AbstractText')[0].content,
         year: contents.css('Year')[0].content,
         link: @url,
         pmid: match[:pmid]
        }
      end

      def match
        @match ||= @url.match(%r{www\.ncbi\.nlm\.nih\.gov/pubmed/(?<pmid>[0-9]+)})
      end
    end
  end
end


# http://www.ncbi.nlm.nih.gov/pubmed/7288891?report=xml&format=text
