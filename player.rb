
class Player

  VERSION = "Killer Ruby Player 1.0"

  def get_rank(card)
  	rank = 0
  	if card == "A"
  		rank = 20
  	elsif card == "K"
  		rank = 15
  	elsif card == "Q"
  		rank = 12
  	elsif card == "J"
  		rank = 10
  	else
  		rank = card.to_i
  	end
  	return rank
  end

  def get_ranks(hole_cards)
  	total_ranks = 0
  	total_ranks += self.get_rank(hole_cards[0]["rank"]) rescue 0
  	total_ranks += self.get_rank(hole_cards[1]["rank"]) rescue 0
  	total_ranks += ( hole_cards[0]["rank"] == hole_cards[1]["rank"] ) ? 20 : 0
  	total_ranks += ( hole_cards[0]["suit"] == hole_cards[1]["suit"] ) ? 40 : 0
  	return total_ranks
  end

  def get_comm_ranks(cards, hole_cards)
  	total_ranks = 0
  	begin
	  	# ha mindegyik ugyanolyan színű
	  	total_ranks += ( [ hole_cards[0]["suit"], hole_cards[1]["suit"], cards[0]["suit"], cards[1]["suit"], cards[2]["suit"] ].uniq.length == 1 ) ? 100 : 0
	  	# ha magas párok vannak
	  	total_ranks += ( hole_cards[0]["rank"] == cards[0]["rank"] || hole_cards[1]["rank"] == cards[0]["rank"] ) ? 100 : 0
	  	total_ranks += ( hole_cards[0]["rank"] == cards[1]["rank"] || hole_cards[1]["rank"] == cards[1]["rank"] ) ? 100 : 0
	  	total_ranks += ( hole_cards[0]["rank"] == cards[2]["rank"] || hole_cards[1]["rank"] == cards[2]["rank"] ) ? 100 : 0
	rescue => e
	end
  	return total_ranks
  end

  def bet_request(game_state)
  	begin
	  	in_action = game_state["in_action"]
	  	# $stderr.puts( "in_action: " + in_action.to_s )
	  	player_in_action = game_state["players"].select{ |list| list["id"] == in_action }[0]

	  	# how many players we have
		num_of_players = game_state["players"].select{ |list| list["status"] == "active" }.length
		puts( "num_of_players: " + num_of_players.to_s )

	  	# $stderr.puts( "player_in_action: " + player_in_action.to_s )
	  	minimum_raise = game_state["current_buy_in"].to_f - player_in_action["bet"].to_f
	  	puts( "raise: " + minimum_raise.to_s )

	  	total_ranks = self.get_ranks( player_in_action["hole_cards"] )
	  	puts( "total_ranks: " + total_ranks.to_s )

	  	comm_ranks = self.get_comm_ranks( game_state["community_cards"], player_in_action["hole_cards"] )
	  	puts( "comm_ranks: " + comm_ranks.to_s )

	  	# mikor érdemes megtartani?
	  	# kézben
	  	# 7-esnél nagyobb pár
	  	# 2 ugyanolyan szinű
	  	# kb. ha a total_ranks nagyobb mint 20
	  	if total_ranks < 40
	  		return 0

	  	else

	  		# leosztásból:
		  	# magas lapok, egyszinűek
		  	# sorvalószinűség a leosztásból
		  	if comm_ranks >= 100
				minimum_raise += game_state["minimum_raise"].to_f
			  	minimum_raise += total_ranks
			  	return minimum_raise.to_i
			else
			  	return minimum_raise.to_i
			end
		end

  	rescue => e
		# all in
		puts "ERROR!" + e.to_s + e.backtrace.join("\n")
		return 1000
  	end
  end

  def showdown(game_state)
  	
  end
end
