# frozen_string_literal: true

module Logicuit
  module Circuits
    module SystemLevel
      # TD4
      class CpuTd4 < Base
        tag :TD4

        define_inputs ld0, ld1, ld2, ld3, sel_a, sel_b, im_d0, im_d1, im_d2, im_d3, clock: :ck

        assembling do |ld0, ld1, ld2, ld3, sel_a, sel_b, im_d0, im_d1, im_d2, im_d3|
          # TODO: Implement assembling
        end
      end
    end
  end
end
