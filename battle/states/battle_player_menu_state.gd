extends BattleState


func _update():
	if Input.is_action_just_pressed("scroll_up"):
		battle.battle_interface.increase_chosen_ability_index(-1, battle.player_party_selection.get_selected_character().character_info)
	if Input.is_action_just_pressed("scroll_down"):
		battle.battle_interface.increase_chosen_ability_index(1, battle.player_party_selection.get_selected_character().character_info)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerIdle")
		battle.update_selected_character_ui(battle.enemy_party_selection)
		battle.battle_interface.set_choose_ability_ui_visibility(false)
	if Input.is_action_just_pressed("confirm"):
		if battle.current_mana < battle.battle_interface.get_selected_ability(battle.player_party_selection.get_selected_character().character_info).mana_cost:
			return
		battle.change_to_state("PlayerTarget")
		battle.battle_interface.set_choose_ability_ui_visibility(false)
