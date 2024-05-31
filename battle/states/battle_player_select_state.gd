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


func _update_controls_ui():
	battle.battle_interface.target_label.visible = true
	battle.battle_interface.confirm_label.visible = true
	battle.battle_interface.view_info_label.visible = true
	battle.battle_interface.view_bag_label.visible = true
	battle.battle_interface.end_turn_label.visible = true
