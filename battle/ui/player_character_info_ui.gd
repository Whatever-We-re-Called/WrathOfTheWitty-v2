extends VBoxContainer

@onready var player_icon = %PlayerIcon
@onready var health_progress_bar = %HealthProgressBar
@onready var health_value_label = %HealthValueLabel
@onready var status_effect_texture = %StatusEffectTexture


func init(battle_character: BattleCharacter):
	player_icon.texture = battle_character.character_info.icon_texture
	
	if battle_character.active_status_effect != Constants.ActiveStatusEffect.NONE:
		player_icon.modulate = Constants.get_status_effect_color(battle_character.active_status_effect)
		status_effect_texture.texture = Constants.get_status_effect_icon(battle_character.active_status_effect)
		status_effect_texture.modulate = Constants.get_status_effect_color(battle_character.active_status_effect)
		status_effect_texture.modulate.a /= 2
	else:
		status_effect_texture.texture = null
	
	health_value_label.text = str(battle_character.health)
	var progress_bar_value = (float(battle_character.health) / float(battle_character.character_info.max_health)) * 100.0
	health_progress_bar.value = int(progress_bar_value)
