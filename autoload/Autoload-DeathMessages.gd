extends Node

var suicide_messages = [
	"%s was jorking their weinor and died",
	"%s wasn't ready for Freddy",
	"%s ran out of RAM"
]

# messages where player's name is first
var killed_messages_player = [
	"%s was RDM'd by %s",
	"%s tried to 1v1 %s (he failed)"
]

# messages where player2's name is first
var killed_messages_player2 = [
	
]

func get_death_message(reason:String, playerName:String, player2Name:String = ""):
	match reason:
		"suicide":
			return suicide_messages[randi_range(0, (suicide_messages.size() - 1))]
		"killed":
			var whichArray = randi_range(0, 1)
			if whichArray == 1:
				return killed_messages_player[randi_range(0, (killed_messages_player.killed_messages_player() - 1))]
			else:
				return killed_messages_player2[randi_range(0, (killed_messages_player2.killed_messages_player() - 1))]
