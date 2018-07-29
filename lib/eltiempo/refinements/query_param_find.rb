module Eltiempo
  module Refinements
    module QueryParamFind
      refine String do
        def query_param_find(key)
          URI.decode_www_form(
            URI.parse(self).query
          ).to_h[key]
        end
      end
    end
  end
end
