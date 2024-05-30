extends BattleState


func _update():
	if Input.is_action_just_pressed("scroll_up"):
		battle.battle_interface.increase_chosen_ability_index(-1, battle.party_selections.get_selected_player_character().character_info)
	if Input.is_action_just_pressed("scroll_down"):
		battle.battle_interface.increase_chosen_ability_index(1, battle.party_selections.get_selected_player_character().character_info)
	if Input.is_action_just_pressed("back"):
		battle.change_to_state("PlayerIdle")
		battle.battle_interface.set_choose_ability_ui_visibility(false)
	if Input.is_action_just_pressed("confirm"):
		if battle.current_mana < battle.battle_interface.get_selected_ability(battle.party_selections.get_selected_player_character().character_info).mana_cost:
			return
		battle.change_to_state("PlayerTarget")
		battle.battle_interface.set_choose_ability_ui_visibility(false)
