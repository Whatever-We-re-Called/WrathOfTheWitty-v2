extends BattleState


func _enter():
	battle.battle_selections.update_ui(battle.player_characters, false, false, false)
	battle.reset_current_selected_abilities()
	
	battle.change_to_state("EnemyAttack")
