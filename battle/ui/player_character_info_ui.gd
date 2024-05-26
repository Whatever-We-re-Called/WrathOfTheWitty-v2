extends VBoxContainer

@onready var player_icon = %PlayerIcon
@onready var health_progress_bar = %HealthProgressBar
@onready var health_value_label = %HealthValueLabel


func init(battle_character: BattleCharacter):
	player_icon.texture = battle_character.character_info.icon_texture
	
	health_value_label.text = str(battle_character.health)
	var progress_bar_value = (float(battle_character.health) / float(battle_character.character_info.max_health)) * 100.0
	health_progress_bar.value = int(progress_bar_value)
