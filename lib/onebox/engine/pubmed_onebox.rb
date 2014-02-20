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
        pre = doc.xpath("//pre")
        xml = "<root>" + pre.text + "</root>"
        contents = Nokogiri::XML(xml)
        initials = contents.css("Initials").map{|x| x.content}
        last_names = contents.css("LastName").map{|x| x.content}
        author_list = (initials.zip(last_names)).map{|i,l| i + " " + l}
        pub_date = contents.css("PubDate")
        if author_list.length > 1 then
          author_list[-2] = author_list[-2] + " and " + author_list[-1]
          author_list.pop
        end
        {
         title: contents.css("ArticleTitle")[0].content,
         authors: author_list.join(", "),
         journal: contents.css("Title")[0].content,
         abstract: contents.css("AbstractText")[0].content,
         month: pub_date.css("Month")[0].content,
         year: pub_date.css("Year")[0].content,
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
