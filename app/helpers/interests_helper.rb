module InterestsHelper
  #This method when called will return an array of ActiveRecords having 
  #all interests in the database that are not deleted.
  def get_all_interests
    interests=Interest.where(:deleted => nil)
  end


  
  

end
