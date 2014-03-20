module Onebox
  module Engine
    class ArxivOnebox
      include Engine
      include LayoutSupport

      matches do
        http
        domain("www.arxiv")
        tld("org")
        has("/abs/")
      end

      private

      def get_xml
        doc = Nokogiri::XML(open("http://export.arxiv.org/api/query?id_list=" + match[:id]))
        pre = doc.xpath("//pre")
        Nokogiri::XML("<root>" + pre.text + "</root>")
      end

      def authors_of_xml(xml)
        name_list = xml.css("name").map{|x| x.content}
        name_list.join(", ")
      end

      def data
         xml = get_xml()
         {
         title: xml.css("title")[0].content,
         authors: authors_of_xml(xml),
         summary: xml.css("summary")[0].content,
         date: xml.css("published")[0].content,
         link: @url,
         id: match[:id]
        }
      end

      def match
        @match ||= @url.match(%r{www\.arxiv\.org/abs/(?<id>[a-z/0-9]+)})
      end
    end
  end
end
