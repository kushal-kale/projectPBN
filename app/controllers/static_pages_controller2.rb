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
	  results = Parallel.map(lines, in_processes: 15) { |l| 
		  future{
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
	  }
	  render text: my(@hash).html_safe;
  end
end