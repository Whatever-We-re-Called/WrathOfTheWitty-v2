extends BattleState


func _enter():
	for character in battle.enemy_characters:
		character.handle_turn_start()
	battle.battle_selections.update_ui(battle.player_characters, false, false, false)
	battle.reset_current_selected_abilities()
	
	battle.change_to_state("EnemyAttack")
