extends ColorRect

@onready var health_container = %HealthContainer
@onready var health_progress_bar = %HealthProgressBar
@onready var health_value_label = %HealthValueLabel


func update_health(battle_character: BattleCharacter, show: bool):
	if not show:
		health_container.visible = false
	else:
		health_container.visible = true
		health_value_label.text = str(battle_character.health)
		var progress_bar_value = (float(battle_character.health) / float(battle_character.character_info.max_health)) * 100.0
		health_progress_bar.value = int(progress_bar_value)
