require 'test_helper'

module Eltiempo
  module Refinements
    class QueryParamFindTest < Minitest::Test
      class Dummy
        using QueryParamFind

        def url_from_google
          <<~EOS.delete("\n")
            https://www.google.com/search?source=hp&ei=3gRgW_THO4GclwTN57GQDQ
            &q=buenos+d%C3%ADas&oq=buenos+d%C3%ADas&gs_l=psy-ab.3..0i131k1l3j
            0l7.4227.5840.0.5986.13.9.0.3.3.0.110.678.7j1.9.0....0...1c.1j4.6
            4.psy-ab..1.12.792.6..35i39k1j0i67k1.90.RGghi9OPeL0
          EOS
        end

        def get_the_search_term
          url_from_google.query_param_find('q')
        end
      end

      def setup
        @mock = Dummy.new
      end

      def test_a_string_knows_how_to_get_a_query_param
        assert_equal @mock.get_the_search_term, 'buenos días'
      end
    end
  end
end
