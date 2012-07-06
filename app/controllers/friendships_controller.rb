class FriendshipsController < ApplicationController

  before_filter {user_authenticated?}

=begin
  This is the controller responsible of indexing frineds
  Input: Nothing
  Output: Nothing  
  Author: Yahia 
=end
  def index
    @user = current_user
    @friends = @user.friends
    @pending_invited_by = @user.pending_invited_by
    @pending_invited = @user.pending_invited
    @friends = @friends + @pending_invited + @user.blockers
    @friends.map{|a| if a.name.nil? then a.name = a.email.split('@')[0] end}
    @friends.sort! {|a,b| a.email <=> b.email}
    @friends = @friends.paginate(:per_page => 5, :page=> params[:page])
    if @friends.empty? 
      flash[:friendship_approved] = 'You have no approved friendships $blue'
    end 
    render layout: 'mobile_template'
  end

=begin
  This is the controller resposnsible of cerating a new friendship
  (requesting)
  The query_forward  variable is got from the search from and will
  help us not to have our search done again each time we request
  a friendship
  Input: params[:friend_id]
  Output: Nothing
  Author: Yahia 
=end
  def create
    @user = current_user
    @friend = User.find(params[:friend_id])
    @friendship_created = @user.invite(@friend)
    if @friendship_created
      flash[:request_sent] = 'Frindship request has succesffully been sent $green'
      # for the log file 
      l = Log.new
      l.user_id_1 = @user.id
      l.user_id_2 = @friend.id
      name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
      name_2 = if @friend.name.nil? then @friend.email.split('@')[0] else @friend.name end
      l.message = "#{name_1.humanize} requested friendship of #{name_2.humanize}"
      l.loggingtype = 0
      l.save
    else 
      flash[:request_not_sent] = 'Frindship request was not sent $red'
    end  

    redirect_to action: "index"
  end

=begin
  This is the controller responsible of accepting frinedship
  when this controller is active, the current user will accept
  the friendship request sent by the user with the id passed
  in the params
  Input: params[:friend_id]
  Output: Nothing
  Author: Yahia 
=end
  def accept
    @user = current_user
    @friend = User.find(params[:friend_id])
    @friendship_approved = @user.approve(@friend)
    @friends = @user.friends
    @pending_invited_by = @user.pending_invited_by
    l = Log.new
    l.user_id_1 = @user.id
    l.user_id_2 = @friend.id
    name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
    name_2 = if @friend.name.nil? then @friend.email.split('@')[0] else @friend.name end
    l.message = "#{name_1.humanize} accepted friendship of #{name_2.humanize}"
    l.loggingtype = 0
    l.save
    flash[:freindship_accept] = "You and #{name_2.humanize} are now friends $green"
    redirect_to action: 'pending'
  end

=begin
  This is the controller responsible of ignoring frinedship
  Input: parmas[:friend_id]
  Output: Nothing
  Author: Yahia 
=end
  def remove
    @user = current_user
    @friend = User.find(params[:friend_id])
    @friendship = @user.send(:find_any_friendship_with, @friend)
    if @friendship
      @friendship.delete
      @removed = true
      flash[:friendship_removed] = "Friendship removed #{@friend.email} $green"
    else 
      flash[:friendship_removed] = "Friendship was not #{@friend.email} $red"
    end
    l = Log.new
    l.user_id_1 = @user.id
    l.user_id_2 = @friend.id
    name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
    name_2 = if @friend.name.nil? then @friend.email.split('@')[0] else @friend.name end
    l.message = "#{name_1.humanize} removed friendship of #{name_2.humanize}"
    l.loggingtype = 0
    l.save

    redirect_to action: "index"
  end

  def remove_request
    @user = current_user
    @friend = User.find(params[:friend_id])
    @friendship = @user.send(:find_any_friendship_with, @friend)
    if @friendship
      @friendship.delete
      @removed = true
      flash[:request_removed] = "Friendship request removed #{@friend.email} $green"
    else 
      flash[:request_not_removed] = "Friendship request was not #{@friend.email} $red"
    end
    l = Log.new
    l.user_id_1 = @user.id
    l.user_id_2 = @friend.id
    name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
    name_2 = if @friend.name.nil? then @friend.email.split('@')[0] else @friend.name end
    l.message = "#{name_1.humanize} removed friendship requst of #{name_2.humanize}"
    l.loggingtype = 0
    l.save

    redirect_to action: "index"

  end 

=begin
  This is the controller responsible of blocking a user (not receiving
  frineship requests from him in the first place)
  Input: params[:friend_id]
  Output: Nothing  
  Author: Yahia 
=end
  def block
    @user = current_user
    @friend = User.find(params[:friend_id])
    @user.block @friend

    l = Log.new
    l.user_id_1 = @user.id
    l.user_id_2 = @friend.id
    name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
    name_2 = if @friend.name.nil? then @friend.email.split('@')[0] else @friend.name end
    l.message = "#{name_1.humanize} blocked #{name_2.humanize}"
    l.loggingtype = 0
    l.save
    flash[:block_success] = "#{name_2.humanize} was blocked successfully $green"    
    redirect_to action: 'pending'
  end

=begin
  This is the controller responsible of unblocking a user
  Input: params[:friend_id]
  Output: Nothing  
  Author: Yahia 
=end
  def unblock
    @user = current_user
    @friend = User.find(params[:friend_id])
    @user.unblock @friend

    l = Log.new
    l.user_id_1 = @user.id
    l.user_id_2 = @friend.id
    name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
    name_2 = if @friend.name.nil? then @friend.email.split('@')[0] else @friend.name end
    l.message = "#{name_1.humanize} blocked #{name_2.humanize}"
    l.loggingtype = 0
    l.save
    flash[:blocked] = "#{name_2.humanize} was unblocked successfully $green"    
    redirect_to action: 'pending'
  end


=begin
  This is the controller responsible for the search of users 
  (to find friends)
  Input: params[:query]
  Output: Nothing  
  Author: Yahia 
=end
  def search
    @user = current_user
    @query = params[:query]
    @resulted_users = Admin.search_user(@query)
    @resulted_users.delete @user
    @resulted_users.sort! {|a,b| a.email <=> b.email}
    @resulted_users = @resulted_users.paginate(:per_page => 5, :page=> params[:page])
    render layout: 'mobile_template'
  end 

=begin
  This is the controller responsible of viewing pending frinedship
  requests. 
  Input: Nothing
  Output: Nothing  
  Author: Yahia 
=end
  def pending 
    @user = current_user
    @inviters = @user.pending_invited_by
    if @inviters.empty?
      flash[:no_pending] = "You have no pending requests $blue"   
      redirect_to action: 'index'
    else 
      @inviters = @inviters.paginate(:per_page => 5, :page=> params[:page])
      render layout: 'mobile_template'
    end 
  end 

end 
