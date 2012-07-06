require 'flickraw'
class FlickrAccountsController < ApplicationController

  before_filter {user_authenticated?}

  API_KEY='443b0e6f88e26df854bdf0d7f7a8c1d5'
  SHARED_SECRET='ff3e3ebe8f31e039'
  


  FlickRaw.api_key=API_KEY
  FlickRaw.shared_secret=SHARED_SECRET
  

=begin
  Description :

  This is the first phase of the OAuth phase that is required by flickr.
  In this phase, first a new Consumer gets created which is basically 
  a client that represents our app talking to flickr. 

  The client asks flickr for a request_token, from which a URL will 
  be generated. The callback url should be changed to the proper server 
  URL. 

  The browser will be redirected to the generated authorization URL. After
  that, flickr will redirect the user back to our app. 


  Note that, the oauth_token_secret is saved in rails default Rails cache to be used
  in the second phase of the authentication process, when the user is redirected back
  from flickr to the call back method

  Input: NO
  Output: NO

  Author: 3OBAD
=end


  def auth

    @user = current_user
    puts @user.email
    Rails.cache.write("user_id", @user.id)
    flickr = FlickRaw::Flickr.new
    token = flickr.get_request_token(:oauth_callback => (
    'http://127.0.0.1:3000/mob/flickr/callback'))
    Rails.cache.write("oauth_token_secret",token['oauth_token_secret'])
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'read')
    redirect_to(auth_url)
  end




=begin
  Description:
  This is the second phase of authentication. In this phase, the user should have 
  authenticated our app through flickr. Then we use the request token and secret 
  token from that exact user to get our access tokens from flickr. Through the 
  access token, we can get the recent photos on  behalf of the user. 

  This is done by simply
  requesting the access token by the oauth_token , oauth_token_secret and oauth_verifier which
  flickr put in the params array. Through this access token the flickr accoun can be made
  thorugh which the system fetches tweets.

  Note that, the oauth_token_secret was stored in Rails default cache at the first phase 
  to be used here during this phase of the authentication process

  Note that, the token expires every 24 houres, so the user will have to renew the token 
  every time he asks for the main feed comming from flickr.

  Input: NO
  Output: NO

  Author: 3OBAD
=end 

  def callback 
    begin
      user_id = Rails.cache.read("user_id")
      @user = User.find(user_id)
      oauth_token_secret = Rails.cache.read("oauth_token_secret")

      flickr = FlickRaw::Flickr.new
      oauth_token = params[:oauth_token]
      oauth_verifier = params[:oauth_verifier]

      raw_token = flickr.get_access_token(params[:oauth_token], oauth_token_secret, params[:oauth_verifier])
      oauth_token = raw_token["oauth_token"]
      oauth_token_secret = raw_token["oauth_token_secret"]

      flickr.access_token = oauth_token
      flickr.access_secret =oauth_token_secret

      if User.find(user_id).flickr_account
         User.find(user_id).flickr_account.delete
      end

      flickr_account = FlickrAccount.create(consumer_key: oauth_token , secret_key: oauth_token_secret)
      User.find(user_id).flickr_account = flickr_account

      unless flickr_account.new_record?
        flash[:notice] = 'Flickr account created $green'
        l = Log.new
        l.loggingtype =0
        l.user_id_1 = @user.id
        name_1 = if @user.name.nil? then @user.email.split('@')[0] else @user.name end
        l.message = "#{name_1} is now connected to flickr account"
        l.save
      else 
        flash[:notice] = 'Flickr account couldn\'t be created $red'
      end 

      redirect_to controller: 'users', action: 'connect_social_accounts'
      
    rescue
      flash[:notice] = 'Couldn\'t connect to flickr $red'
      redirect_to controller: 'users', action: 'connect_social_accounts'
    end
  end
=begin
  Description:
  This method is resposible of deleting the social account of the current user
  Input: NO
  Output: NO
  Author: 3OBAD
=end

  def delete_account
    @user = current_user
    if @user.flickr_account.destroy
      flash[:notice] = 'You are not connected to flickr anymore $green'
    else 
      flash[:notice] = 'Something went wrong. Please try again $red'
    end 
    redirect_to controller: 'users', action: 'connect_social_accounts'
  end   

end
