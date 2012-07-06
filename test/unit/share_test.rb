require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  #Author : Mina Adel
  test "shouldn't create with user id and story id" do
    share = Share.new()
    assert !share.save
  end
end
