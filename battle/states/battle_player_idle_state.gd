extends BattleState


func _enter():
	battle.update_current_selected_abilities(battle.battle_selections.get_selected_player_character().character_info.abilities)
	battle.battle_selections.update_selected_index(battle.enemy_characters, 0)
	battle.battle_selections.update_ui(battle.player_characters, true, false, false)
	battle.battle_selections.update_ui(battle.enemy_characters, true, false, false)


func _exit():
	pass


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.battle_selections.update_selected_index(battle.enemy_characters, -1)
		battle.battle_selections.update_ui(battle.enemy_characters, true, false, false)
	if Input.is_action_just_pressed("target_right"):
		battle.battle_selections.update_selected_index(battle.enemy_characters, 1)
		battle.battle_selections.update_ui(battle.enemy_characters, true, false, false)
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
