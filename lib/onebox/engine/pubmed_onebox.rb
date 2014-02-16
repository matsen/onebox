module Onebox
  module Engine
    class PubmedOnebox
      include Engine

      matches do
        http
        maybe("www.")
        domain("ncbi.nlm.nih")
        tld("gov")
        has("/pubmed/")
      end

      def to_html
        "#{data[:title]}, #{data[:authors]}, #{data[:journal]}"
      end

      private

      def data
        doc = Nokogiri::XML(open(@url + "?report=xml&format=text"))
        pre = doc.xpath('//pre')
        xml = "<root>" + pre.text + "</root>"
        contents = Nokogiri::XML(xml)
        title = contents.css('ArticleTitle')[0].content
        authors = (contents.css('LastName').map{|x| x.content}).join(", ")
        journal = contents.css('Title')[0].content
        { pmid: match[:pmid],
        title: title,
        authors: authors,
        journal: journal,
        link: @url }
      end

      def match
        @match ||= @url.match(%r{www\.ncbi\.nlm\.nih\.gov/pubmed/(?<pmid>[0-9]+)})
      end
    end
  end
end


# http://www.ncbi.nlm.nih.gov/pubmed/7288891?report=xml&format=text
