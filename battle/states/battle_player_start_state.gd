extends BattleState


func _enter():
	battle.current_mana = battle.player_party.max_mana
	battle.battle_interface.update_mana_ui(battle.current_mana)
	await get_tree().process_frame
	battle.change_to_state("PlayerSelect")
