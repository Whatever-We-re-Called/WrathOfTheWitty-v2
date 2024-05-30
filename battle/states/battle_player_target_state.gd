extends BattleState


func _enter():
	battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_TARGET, 0, true)


func _exit():
	battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_TARGETED, 0, true)


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_TARGET, -1, true)
	if Input.is_action_just_pressed("target_right"):
		battle.party_selections.update_selected_character_index(Constants.CharacterSelectState.ENEMY_TARGET, 1, true)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerMenu")
		#battle.update_selected_character_ui(battle.enemy_party_selection)
		battle.battle_interface.set_choose_ability_ui_visibility(false)
	if Input.is_action_just_pressed("confirm"):
		battle.change_to_state("PlayerAttack")
		battle.battle_interface.set_choose_ability_ui_visibility(false)
