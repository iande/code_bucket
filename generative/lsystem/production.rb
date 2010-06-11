# To change this template, choose Tools | Templates
# and open the template in the editor.

module Lsystem
  class Production
    attr_reader :pred, :succ

    def initialize(pred, succ)
      @pred = pred
      @succ = succ
    end
  end
end
