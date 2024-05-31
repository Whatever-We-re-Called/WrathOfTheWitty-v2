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
		battle.change_to_state("PlayerAbilityMenu")


func _update_controls_ui():
	battle.battle_interface.target_label.visible = true
	battle.battle_interface.view_info_label.visible = true
	battle.battle_interface.choose_ability_label.visible = true
	battle.battle_interface.view_bag_label.visible = true
	battle.battle_interface.back_label.visible = true
