class TwitterAccountsController < ApplicationController

  before_filter {user_authenticated?}

=begin
  This is the first phase of the OAuth phase that is required by twitter.
  In this phase, first a new Consumer gets created which is basically 
  a client that represents our app talking to twitter. 

  The client asks twitter for a request_token, from which a URL will 
  be generated. The callback url should be changed to the proper server 
  URL. 

  The browser will be redirected to the generated authorization URL. After
  that, twitter will redirect the user back to our app. 

  Author: Yahia
=end
  def generate_request_token

    #FIXME change IP 
    request_token = TwitterAccount.twitter_consumer.get_request_token(:oauth_callback => 
                "http://127.0.0.1:3000/mob/twitter/generate_access_token")

    url = request_token.authorize_url
    redirect_to(url)
  end 

=begin
  This is the second phase of authentication. In this phase, the user should have 
  authenticated our app through twitter. Then we use the request token and secret 
  token from that exact user to get our access tokens from twitter. Through the 
  access token, we can get the feeds or tweet on behalf of the user. 

  This is done by simply
  requesting the access token by the oauth_token and oauth_verifier which twitter
  put in the params array. Through this access token the twitter accoun can be made
  thorugh which the system fetches tweets.

  Note that, this token does not expire unless the user has explicitly removed
  it from twitter app setting. 

  Author: Yahia
=end 
  def generate_access_token
    @user = current_user
    begin 
      request_token = OAuth::RequestToken.new(TwitterAccount.twitter_consumer,
                      params["oauth_token"], params["oauth_verifier"])
      if @user.twitter_account
        @user.twitter_account.delete
      end
      t_account = @user.create_twitter_account(request_token)

      unless t_account.new_record?
        flash[:notice] = 'You are now connected to twitter $green'
        l = Log.new
        l.user_id_1 = @user.id
        name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
        l.message = "#{name_1.humanize} is now connected to twitter account"
        l.loggingtype = 0
        l.save

      else 
        flash[:notice] = 'Couldn\'t connect to twitter $red'
      end 
      redirect_to controller: 'users', action: 'connect_social_accounts'

    rescue 
      flash[:notice] = 'Couldn\'t connect to twitter $red'
      redirect_to controller: 'users', action: 'connect_social_accounts'
    end 
  end 

=begin 
  This method is resposible of deleting the social account of the current user
  Input: Nothing
  Output: Nothing
  Author: Yahia
=end 
  def delete_account
      @user = current_user
      if @user.twitter_account.destroy
        flash[:notice] = 'You are not connected to twitter anymore $green'
      else 
        flash[:notice] = 'Something went wrong. Please try again $red'
      end 
      redirect_to controller: 'users', action: 'connect_social_accounts'
  end 

end
