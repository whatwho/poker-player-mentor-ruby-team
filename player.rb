
require 'json'

class Player

  VERSION = "Default Ruby folding player"

  def bet_request(game_state)
  	parsed = JSON.parse(game_state)
  	in_action = parsed["in_action"]
  	$stderr.puts( "in_action: " + in_action.to_s )
  	player_in_action = parsed["players"].select{ |list| list["id"] == in_action }
  	$stderr.puts( "player_in_action: " + player_in_action.to_s )
    1000
  end

  def showdown(game_state)
  	
  end
end
