extends BattleState


func _enter():
	var enemy_selected_index = battle.battle_selections.get_selected_index(battle.enemy_characters)
	battle.battle_selections.set_targeted_index(battle.enemy_characters, enemy_selected_index)
	if battle.get_current_selected_ability().does_target_all():
		battle.battle_selections.set_is_targeting_all(battle.enemy_characters, true)
		battle.lock_camera_on_party(battle.enemy_characters)
	battle.battle_selections.update_ui(battle.player_characters, true, false, false)
	battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)


func _exit():
	var enemy_targeted_index = battle.battle_selections.get_targeted_index(battle.enemy_characters)
	battle.battle_selections.set_selected_index(battle.enemy_characters, enemy_targeted_index)


func _update():
	if Input.is_action_just_pressed("target_left"):
		battle.battle_selections.update_targeted_index(battle.enemy_characters, -1)
		battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)
	if Input.is_action_just_pressed("target_right"):
		battle.battle_selections.update_targeted_index(battle.enemy_characters, 1)
		battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerAbilityMenu")
	if Input.is_action_just_pressed("confirm"):
		battle.change_to_state("PlayerAttack")


func _update_controls_ui():
	battle.battle_interface.target_label.visible = true
	battle.battle_interface.confirm_label.visible = true
	battle.battle_interface.view_info_label.visible = true
	battle.battle_interface.back_label.visible = true
