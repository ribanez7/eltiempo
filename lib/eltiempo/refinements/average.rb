module Eltiempo
  module Refinements
    module Average
      refine Array do
        def average
          sum / size
        end
      end
    end
  end
end
