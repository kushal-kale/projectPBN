=begin
require 'open-uri'
require 'uri'
require 'future'
class StaticPagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ext]
  @hash = "Kushal";
  def home
  end
  def results
  end
  def ext
	  @hash = {};
	  postvar = params[:DomainName];
	  lines=postvar.split("\n");
	  lines.each do |l|
		  Thread. new {
			  if(l[-1] != '/')
		      	  l += "/";
	  	  	  end
		      begin
			      page = MetaInspector.new(l);
		  	      doc = page.parsed;
		  	      doc.xpath('//a[@href]').each do |link|
				      if (link['href'].include? "fitnesstep1")
  			  	        @hash[link.text.strip] = link['href']
			          end
		  	      end
		      rescue
		          next
		      end
		  }
	  end
	  render text: my(@hash).html_safe;
  end
end

=end
require 'open-uri'
require 'uri'
require 'future'
class StaticPagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ext]
  @hash = "Kushal";
  def home
  end
  def results
  end
  def ext
	  @hash = {};
	  postvar = params[:DomainName];
	  lines=postvar.split("\n");
	  lines.each { |x| 
		  if(x[-1] != '/')
		      x << "/";
	  	  end
	  }
	  results = Parallel.map(lines, in_threads: 25) { |l| 
		      begin
			      page = MetaInspector.new(l);
		  	      doc = page.parsed;
		  	      doc.xpath('//a[@href]').each do |link|
				      if (link['href'].include? "fitnesstep1")
  			  	          @hash[link.text.strip] = link['href']
			          end
		  	      end
			  rescue
			      next
		      end
	  }
	  render text: my(@hash).html_safe;
  end
end