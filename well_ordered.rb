# WellOrdered provides a means for well ordered (though not necessarily finite)
# objects to be handled like other collections, such as arrays and hashes.
# In order to include the WellOrdered module, a class must implement the `pred`,
# and `succ` methods.  Any class that is WellOrdered is also Enumerable.

module WellOrdered
  include Enumerable
end

require 'well_ordered/each'
require 'well_ordered/reverse'
require 'well_ordered/map'
require 'well_ordered/filter'
require 'well_ordered/bounded'
require 'well_ordered/seeds'
require 'well_ordered/overridden'
