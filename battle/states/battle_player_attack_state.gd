extends BattleState


func _enter():
	battle.battle_selections.set_is_targeted(battle.enemy_characters, true)
	battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)
	await get_tree().create_timer(1.0).timeout
	
	_execute_attack()


func _exit():
	battle.battle_selections.set_is_targeting_all(battle.enemy_characters, false)
	battle.camera.unlock()
	
	battle.battle_selections.set_is_targeted(battle.enemy_characters, false)
	battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)


func _execute_attack():
	var selected_ability = battle.get_current_selected_ability()
	var attacker_character = battle.battle_selections.get_selected_player_character()
	var defender_character = battle.battle_selections.get_all_targeted_enemy_characters()
	BattleExecution.try_to_execute(selected_ability, attacker_character, defender_character, battle)
	await get_tree().create_timer(1.0).timeout
	
	battle.update_current_player_mana(-selected_ability.mana_cost)
	battle.change_to_state("PlayerSelect")
