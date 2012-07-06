require 'net/http'
require 'cgi'
module LogsHelper

  def http_get(domain,path,params)
      return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
      return Net::HTTP.get(domain, path)
  end

end
