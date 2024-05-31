extends BattleState


func _enter():
	battle.reset_for_player_turn()
	await get_tree().process_frame
	
	battle.change_to_state("PlayerSelect")
