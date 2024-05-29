extends BattleState


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.enemy_party_selection.increment_selected_index(-1)
		battle.update_selected_character_ui(battle.enemy_party_selection)
	if Input.is_action_just_pressed("target_right"):
		battle.enemy_party_selection.increment_selected_index(1)
		battle.update_selected_character_ui(battle.enemy_party_selection)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerMenu")
		battle.update_selected_character_ui(battle.enemy_party_selection)
		battle.battle_interface.set_choose_ability_ui_visibility(false)
	if Input.is_action_just_pressed("confirm"):
		battle.change_to_state("PlayerAttack")
		battle.battle_interface.set_choose_ability_ui_visibility(false)
