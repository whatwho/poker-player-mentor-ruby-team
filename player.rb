
class Player

  VERSION = "Default Ruby folding player"

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

  def bet_request(game_state)
  	begin
	  	in_action = game_state["in_action"]
	  	# $stderr.puts( "in_action: " + in_action.to_s )
	  	player_in_action = game_state["players"].select{ |list| list["id"] == in_action }[0]
	  	# $stderr.puts( "player_in_action: " + player_in_action.to_s )
	  	minimum_raise = game_state["current_buy_in"].to_f - player_in_action["bet"].to_f + game_state["minimum_raise"].to_f
	  	puts( "raise: " + minimum_raise.to_s )

	  	total_ranks = self.get_ranks( player_in_action["hole_cards"] )
	  	puts( "total_ranks: " + total_ranks.to_s )

	  	# mikor érdemes megtartani?
	  	# kézben
	  	# 7-esnél nagyobb pár
	  	# 2 ugyanolyan szinű
	  	# kb. ha a total_ranks nagyobb mint 20
	  	if total_ranks < 20
	  		return 0
	  	else

	  		# leosztásból:
		  	# magas lapok, egyszinűek
		  	# sorvalószinűség a leosztásból
		  	minimum_raise += total_ranks

		  	return minimum_raise.to_i
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
