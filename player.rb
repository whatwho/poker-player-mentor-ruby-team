
class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
  	begin
	  	in_action = game_state["in_action"]
	  	# $stderr.puts( "in_action: " + in_action.to_s )
	  	player_in_action = game_state["players"].select{ |list| list["id"] == in_action }[0]
	  	# $stderr.puts( "player_in_action: " + player_in_action.to_s )
	  	minimum_raise = game_state["current_buy_in"].to_f - player_in_action["bet"].to_f + game_state["minimum_raise"].to_f
	  	minimum_raise += rand(1..5)
	  	$stderr.puts( "raise: " + minimum_raise.to_s )
	  	return minimum_raise.to_i
  	rescue Error => e
		# all in
		return 1000
  	end
  end

  def showdown(game_state)
  	
  end
end
