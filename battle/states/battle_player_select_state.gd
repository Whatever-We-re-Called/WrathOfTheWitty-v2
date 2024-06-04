extends BattleState


func _enter():
	battle.battle_selections.set_is_selected(battle.player_characters, false)
	battle.battle_selections.update_selected_index(battle.player_characters, 0)
	battle.battle_selections.update_ui(battle.player_characters, true, false, false)
	battle.battle_selections.update_ui(battle.enemy_characters, false, false, false)


func _exit():
	battle.battle_selections.set_is_selected(battle.player_characters, true)


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.battle_selections.update_selected_index(battle.player_characters, -1)
		battle.battle_selections.update_ui(battle.player_characters, true, false, false)
	if Input.is_action_just_pressed("target_right"):
		battle.battle_selections.update_selected_index(battle.player_characters, 1)
		battle.battle_selections.update_ui(battle.player_characters, true, false, false)
	if Input.is_action_just_pressed("confirm"):
		battle.change_to_state("PlayerIdle")
	if Input.is_action_just_pressed("end_turn"):
		battle.change_to_state("EnemyStart")


func _update_controls_ui():
	battle.battle_interface.target_label.visible = true
	battle.battle_interface.confirm_label.visible = true
	battle.battle_interface.view_info_label.visible = true
	battle.battle_interface.view_bag_label.visible = true
	battle.battle_interface.end_turn_label.visible = true
