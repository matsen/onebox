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
        "#{match[:pmid]}"
      end

      private

      def data
        { pmid: match[:pmid], link: @url }
      end

      def match
        @match ||= @url.match(%r{www\.ncbi\.nlm\.nih\.gov/pubmed/(?<pmid>[0-9]+)})
      end
    end
  end
end


# http://www.ncbi.nlm.nih.gov/pubmed/7288891?report=xml&format=text
