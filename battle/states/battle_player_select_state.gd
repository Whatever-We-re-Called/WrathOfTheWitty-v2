extends BattleState


func _enter():
	battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.PLAYER_SELECT, 0, true)
	battle.party_selections.hide_enemy_selected_state()


func _exit():
	battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.PLAYER_SELECTED, 0, true)


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.PLAYER_SELECT, -1, true)
	if Input.is_action_just_pressed("target_right"):
		battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.PLAYER_SELECT, 1, true)
	if Input.is_action_just_pressed("confirm"):
		battle.change_to_state("PlayerIdle")
		#battle.update_selected_character_ui(battle.enemy_party_selection)
