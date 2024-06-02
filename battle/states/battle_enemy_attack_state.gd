extends BattleState


func _enter():
	var rng = RandomNumberGenerator.new()
	for i in range(battle.enemy_characters.size()):
		var enemy_character = battle.enemy_characters[i]
		if enemy_character.health <= 0: continue
		
		battle.party_selections.hide_player_selected_state()
		battle.reset_current_selected_abilities()
		
		battle.party_selections.set_selected_character_index(Constants.CharacterSelectState.ENEMY_SELECT, i, true)
		await get_tree().create_timer(1).timeout
		
		var target_player_index = -1
		while target_player_index < 0:
			var test_target_player_index = rng.randi_range(0, battle.player_characters.size() - 1)
			if battle.player_characters[test_target_player_index].health >= 0:
				target_player_index = test_target_player_index
		battle.party_selections.set_selected_character_index(Constants.CharacterSelectState.ENEMY_SELECTED, i, true)
		battle.party_selections.set_selected_character_index(Constants.CharacterSelectState.PLAYER_TARGET, target_player_index, true)
		await get_tree().create_timer(1).timeout
		
		var used_ability_index = rng.randi_range(0, enemy_character.character_info.abilities.size() - 1)
		var used_ability = enemy_character.character_info.abilities[used_ability_index]
		battle.update_current_selected_ability(used_ability)
		battle.party_selections.set_selected_character_index(Constants.CharacterSelectState.PLAYER_TARGETED, target_player_index, true)
		await get_tree().create_timer(1).timeout
		
		var attacker_character = battle.party_selections.get_selected_enemy_character()
		var defender_character = battle.party_selections.get_selected_player_character()
		BattleExecution.try_to_execute(used_ability, attacker_character, defender_character, battle)
		battle.battle_interface.update_player_character_info(battle.player_characters)
		await get_tree().create_timer(1).timeout
	
	battle.change_to_state("PlayerStart")
