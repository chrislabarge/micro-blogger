require 'jumpstart_auth'

class MicroBlogger

	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def run	
		puts "Welcome to the JSL Twitter Client"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_friends(parts[1..-1].join(" "))
				when 'latest' then everyones_last_tweet
				else
					puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			"Whoops the message is too long, 140 characters max."
		end
	end

	def followers_list
		@client.followers.collect do |follower| 
			@client.user(follower).screen_name
		end
	end

	def spam_my_friends(message)
		followers_list.each { |follower| dm(follower, message) }
	end

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		message = "d @#{target} #{message}"
		
		screen_names = followers_list
		
		 if screen_names.include?(target)
		 	tweet(message)
		 else	
			puts "I'm sorry, that user must be following you in order to Direct Message"
		 end	
	end	

	def everyones_last_tweet
		puts "what"	

		friends = @client.friends
		
		friends.each do |friend|
			screen_name = @client.user(friend).screen_name
			post = @client.user(friend).status.text
			created_at = @client.user(friend).status.created_at.strftime("%A, %b %d")

			puts "#{screen_name} made a tweet at #{created_at}...." 
			puts post
		end
		
	end


end

blogger = MicroBlogger.new
blogger.run

