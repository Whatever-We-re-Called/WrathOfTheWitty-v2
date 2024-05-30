extends BattleState


func _enter():
	battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_SELECT, 0, true)


func _exit():
	battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_TARGET, 0, true)


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_SELECT, -1, true)
	if Input.is_action_just_pressed("target_right"):
		battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_SELECT, 1, true)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerSelect")
	if Input.is_action_just_pressed("choose_ability"):
		battle.change_to_state("PlayerMenu")
		battle.battle_interface.set_choose_ability_ui_visibility(true, battle.party_selections.get_selected_player_character().character_info)
