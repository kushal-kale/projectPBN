class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :my
  attr_accessor :output_buffer
    def my(hash)
	  a = '';
		hash.each { 
			|key, value| 
			
			a += "\n#{key}, #{value}<br />"; 
		}
		return a;
    end
	def hello
      render html: "hello, world!"
	end
end
