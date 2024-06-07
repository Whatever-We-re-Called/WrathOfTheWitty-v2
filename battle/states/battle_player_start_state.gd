extends BattleState


func _enter():
	for character in battle.player_characters:
		character.handle_turn_start()
	battle.reset_for_player_turn()
	await get_tree().process_frame
	
	battle.change_to_state("PlayerSelect")
