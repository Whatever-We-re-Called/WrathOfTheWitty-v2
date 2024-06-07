extends BattleState


func _enter():
	var rng = RandomNumberGenerator.new()
	for i in range(battle.enemy_characters.size()):
		var enemy_character = battle.enemy_characters[i]
		if enemy_character.health <= 0: continue
		
		# Select enemy.
		battle.battle_selections.update_ui(battle.player_characters, false, false, false)
		battle.reset_current_selected_abilities()
		
		battle.battle_selections.set_selected_index(battle.enemy_characters, i)
		battle.battle_selections.update_ui(battle.enemy_characters, true, false, false)
		await get_tree().create_timer(1).timeout
		
		battle.battle_selections.set_is_selected(battle.enemy_characters, true)
		battle.battle_selections.update_ui(battle.enemy_characters, true, false, false)
		
		# Target player and choose ability.
		var target_player_index = -1
		while target_player_index < 0:
			var test_target_player_index = rng.randi_range(0, battle.player_characters.size() - 1)
			if battle.player_characters[test_target_player_index].health >= 0:
				target_player_index = test_target_player_index
		var used_ability_index = rng.randi_range(0, enemy_character.character_info.abilities.size() - 1)
		var used_ability = enemy_character.character_info.abilities[used_ability_index]
		battle.update_current_selected_ability(used_ability)
		if used_ability.does_target_all():
			battle.battle_selections.set_is_targeting_all(battle.player_characters, true)
			battle.lock_camera_on_party(battle.player_characters)
		battle.battle_selections.set_targeted_index(battle.player_characters, target_player_index)
		battle.battle_selections.update_ui(battle.player_characters, false, true, false)
		await get_tree().create_timer(1).timeout
		
		battle.battle_selections.set_is_targeted(battle.player_characters, true)
		battle.battle_selections.update_ui(battle.player_characters, false, true, false)
		await get_tree().create_timer(1).timeout
		
		var attacker_character = battle.battle_selections.get_selected_enemy_character()
		var defender_characters = battle.battle_selections.get_all_targeted_player_characters()
		var execute_ability = true
		
		if attacker_character.active_status_effect == Constants.ActiveStatusEffect.FEAR:
			if rng.randf_range(0.0, 1.0) <= CharacterInfo.FEAR_IGNORE_CHANCE:
				execute_ability = false
		
		if execute_ability:
			BattleExecution.try_to_execute(used_ability, attacker_character, defender_characters, battle)
		else:
			attacker_character.start_ignore_animation()
			battle.battle_selections.update_selected_index(battle.enemy_characters, 0)
		await get_tree().create_timer(1.5).timeout
		
		battle.battle_selections.set_is_targeting_all(battle.player_characters, false)
		battle.camera.unlock()
		battle.battle_selections.set_is_selected(battle.enemy_characters, false)
		battle.battle_selections.update_ui(battle.player_characters, true, false, false)
		battle.battle_selections.set_is_targeted(battle.player_characters, false)
		battle.battle_selections.update_ui(battle.player_characters, false, true, false)
	
	battle.change_to_state("PlayerStart")


