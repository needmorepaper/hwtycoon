extends Button

func _pressed():
	## Recieve our player's names
	## BUG: Can't find the node for some fucking reason (race condition?)
	# var CompanyName = get_node("$CompanyName")
	# var CEOFirstName = get_node("$CEOFirstName")
	# var CEOLastName = get_node("$CEOLastName")
	# var PlayerCompanyGlobal = get_node("/root/PlayerCompany")
	# print("Player name: ", CEOFirstName.get_text(), " ", CEOLastName.get_text())
	# print("Company name: " + CompanyName.get_text())
	
	## This is where all user data is recorded to
	## and is initialized to this during a new game.
	# PlayerCompanyGlobal.set_player_stats("CEOName", CEONameNode.get_text())
	# PlayerCompanyGlobal.set_player_stats("CompanyName", CompanyNameNode.get_text())
	# PlayerCompanyGlobal.set_player_stats("Cash", 500000)
	# print("PlayerCompany dictionary initialized for player")
	
	## TODO: Change stats based on difficulty.
	
	## Switch scene to playing area, new game processing is done
	print("New game initialized")
	get_tree().change_scene_to_file("res://scenes/main_play.tscn")
