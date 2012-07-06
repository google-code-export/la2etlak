module AutoComplete      
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     auto_complete_for :post, :title
  #   end
  #
  #   # View
  #   <%= text_field_with_auto_complete :post, title %>
  #
  # By default, auto_complete_for limits the results to 10 entries,
  # and sorts by the given field.
  # 
  # auto_complete_for takes a third parameter, an options hash to
  # the find method used to search for the records:
  #
  #   auto_complete_for :post, :title, :limit => 15, :order => 'created_at DESC'
  #
  # For help on defining text input fields with autocompletion, 
  # see ActionView::Helpers::JavaScriptHelper.
  #
  # For more examples, see script.aculo.us:
  # * http://script.aculo.us/demos/ajax/autocompleter
  # * http://script.aculo.us/demos/ajax/autocompleter_customized
  module ClassMethods
    #this method is used for getting the auto complete result from three tables together Interest ,Users and Stories
    def auto_complete_for(object, method, options = {})
      define_method("auto_complete_for_#{object}_#{method}") do
        find_options1 = { 
          :conditions => [ "LOWER(name) LIKE ?", '%' + params[object][method].downcase + '%' ], 
          :order => "name ASC",
          :limit => 10 }.merge!(options)
        find_options2 = { 
          :conditions => [ "LOWER(name) LIKE ?", '%' + params[object][method].downcase + '%' ], 
          :order => "name ASC",
          :limit => 10 }.merge!(options)
        find_options3 = { 
          :conditions => [ "LOWER(title) LIKE ?", '%' + params[object][method].downcase + '%' ], 
          :order => "title ASC",
          :limit => 10 }.merge!(options)    
        @items1 = User.find(:all, find_options1)
        @items2 = Interest.find(:all, find_options2)
        @items3 = Story.find(:all, find_options3)
        @items = @items1 + @items2 + @items3
        render :inline => "<%= auto_complete_result @items%>"
      end
    end
  end
  
end