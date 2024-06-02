extends BattleState


func _enter():
	battle.party_selections.hide_player_selected_state()
	battle.reset_current_selected_abilities()
	
	battle.change_to_state("EnemyAttack")
