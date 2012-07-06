class AutocompleteController < ApplicationController
=begin
   by stating this line the controller is now  seeing the plugin of auto complete
    Author: Gasser
=end
  auto_complete_for :autocomplete, :query
end
