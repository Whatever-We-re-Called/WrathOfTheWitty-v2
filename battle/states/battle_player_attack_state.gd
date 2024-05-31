extends BattleState


func _enter():
	await get_tree().create_timer(1.0).timeout
	var selected_ability = battle.current_player_selected_ability
	var attacker_character = battle.party_selections.get_selected_player_character()
	var defender_character = battle.party_selections.get_selected_enemy_character()
	BattleExecution.try_to_execute(selected_ability, attacker_character, defender_character, battle)
	
	await get_tree().create_timer(1.0).timeout
	battle.update_current_player_mana(-selected_ability.mana_cost)
	battle.change_to_state("PlayerSelect")
