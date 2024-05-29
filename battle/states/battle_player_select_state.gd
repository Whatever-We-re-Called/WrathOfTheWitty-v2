extends BattleState


func _update():
	print("update")
	if Input.is_action_just_pressed("target_left"):
		battle.player_party_selection.increment_selected_index(-1)
		battle.update_selected_character_ui(battle.player_party_selection)
	if Input.is_action_just_pressed("target_right"):
		battle.player_party_selection.increment_selected_index(1)
		battle.update_selected_character_ui(battle.player_party_selection)
	if Input.is_action_just_pressed("confirm"):
		battle.change_to_state("PlayerIdle")
		battle.update_selected_character_ui(battle.enemy_party_selection)
