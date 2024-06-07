extends BattleState


func _enter():
	battle.battle_selections.set_is_targeted(battle.enemy_characters, true)
	battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)
	await get_tree().create_timer(1.0).timeout
	
	_execute_ability()


func _exit():
	battle.battle_selections.set_is_targeting_all(battle.enemy_characters, false)
	battle.camera.unlock()
	
	battle.battle_selections.set_is_targeted(battle.enemy_characters, false)
	battle.battle_selections.update_ui(battle.enemy_characters, false, true, false)


func _execute_ability():
	var selected_ability = battle.get_current_selected_ability()
	var attacker_character = battle.battle_selections.get_selected_player_character()
	var defender_character = battle.battle_selections.get_all_targeted_enemy_characters()
	var execute_ability = true
	
	var rng = RandomNumberGenerator.new()
	if attacker_character.active_status_effect == Constants.ActiveStatusEffect.FEAR:
		if rng.randf_range(0.0, 1.0) <= CharacterInfo.FEAR_IGNORE_CHANCE:
			execute_ability = false
	
	if execute_ability:
		BattleExecution.try_to_execute(selected_ability, attacker_character, defender_character, battle)
	else:
		attacker_character.start_ignore_animation()
		battle.battle_selections.update_selected_index(battle.player_characters, 0)
	await get_tree().create_timer(1.5).timeout
	
	battle.update_current_player_mana(-selected_ability.mana_cost)
	battle.change_to_state("PlayerSelect")
