class_name BattleCharacter extends Node2D

@export_group("Drop Shadow (Temp?)")
@export var select_drop_shadow_texture: Texture2D
@export var target_drop_shadow_texture: Texture2D
@export var none_drop_shadow_color: Color
@export var select_player_drop_shadow_color: Color
@export var selected_player_drop_shadow_color: Color
@export var select_enemy_drop_shadow_color: Color
@export var selected_enemy_drop_shadow_color: Color

@onready var sprite_2d = $Sprite2D
@onready var health_container = %HealthContainer
@onready var health_progress_bar = %HealthProgressBar
@onready var health_value_label = %HealthValueLabel
@onready var drop_shadow = %DropShadow
@onready var drop_shadow_sprite = %DropShadowSprite
@onready var weak_tag = %WeakTag
@onready var depression_ui = %DepressionUI
@onready var depression_container = %DepressionContainer
@onready var chain_tag = %ChainTag
@onready var health_animation_player = %HealthAnimationPlayer
@onready var damage_dealt_display = %DamageDealtDisplay
@onready var damage_dealt_display_value = %DamageDealtDisplayValue


var character_info: CharacterInfo
var facing_direction: Constants.FacingDirection
var health: int
var depression_assaulters: Array[BattleCharacter]


func init(character_info: CharacterInfo, facing_direction: Constants.FacingDirection):
	self.character_info = character_info.duplicate()
	self.facing_direction = facing_direction
	
	self.health = character_info.max_health
	
	_init_sprite_2d()


func _init_sprite_2d():
	match facing_direction:
		Constants.FacingDirection.FORWARD_LEFT:
			sprite_2d.texture = character_info.forward_facing_texture
			sprite_2d.flip_h = true
		Constants.FacingDirection.FORWARD_RIGHT:
			sprite_2d.texture = character_info.forward_facing_texture
			sprite_2d.flip_h = false
		Constants.FacingDirection.BACKWARD_LEFT:
			sprite_2d.texture = character_info.backward_facing_texture
			sprite_2d.flip_h = true
		Constants.FacingDirection.BACKWARD_RIGHT:
			sprite_2d.texture = character_info.backward_facing_texture
			sprite_2d.flip_h = false
	sprite_2d.scale = character_info.texture_scale
	
	var sprite_height = sprite_2d.texture.get_height()
	global_position.y -= (sprite_height * character_info.texture_scale.y) / 2.0
	drop_shadow.global_position.y += (sprite_height * character_info.texture_scale.y) / 2.0


func set_drop_shadow(select_state: Constants.CharacterSelectState):
	match select_state:
		Constants.CharacterSelectState.NONE:
			drop_shadow_sprite.modulate = none_drop_shadow_color
			drop_shadow_sprite.texture = select_drop_shadow_texture
			_update_health_ui(false)
		Constants.CharacterSelectState.PLAYER_SELECT:
			drop_shadow_sprite.modulate = select_player_drop_shadow_color
			drop_shadow_sprite.texture = select_drop_shadow_texture
			_update_health_ui(false)
		Constants.CharacterSelectState.PLAYER_SELECTED:
			drop_shadow_sprite.modulate = selected_player_drop_shadow_color
			drop_shadow_sprite.texture = select_drop_shadow_texture
			_update_health_ui(false)
		Constants.CharacterSelectState.PLAYER_TARGET:
			drop_shadow_sprite.modulate = select_player_drop_shadow_color
			drop_shadow_sprite.texture = target_drop_shadow_texture
			_update_health_ui(true)
		Constants.CharacterSelectState.PLAYER_TARGETED:
			drop_shadow_sprite.modulate = selected_player_drop_shadow_color
			drop_shadow_sprite.texture = target_drop_shadow_texture
			_update_health_ui(true)
		Constants.CharacterSelectState.ENEMY_SELECT:
			drop_shadow_sprite.modulate = select_enemy_drop_shadow_color
			drop_shadow_sprite.texture = select_drop_shadow_texture
			_update_health_ui(true)
		Constants.CharacterSelectState.ENEMY_SELECTED:
			drop_shadow_sprite.modulate = selected_enemy_drop_shadow_color
			drop_shadow_sprite.texture = select_drop_shadow_texture
			_update_health_ui(true)
		Constants.CharacterSelectState.ENEMY_TARGET:
			drop_shadow_sprite.modulate = select_enemy_drop_shadow_color
			drop_shadow_sprite.texture = target_drop_shadow_texture
			_update_health_ui(true)
		Constants.CharacterSelectState.ENEMY_TARGETED:
			drop_shadow_sprite.modulate = selected_enemy_drop_shadow_color
			drop_shadow_sprite.texture = target_drop_shadow_texture
			_update_health_ui(true)


func _update_health_ui(display: bool):
	if not display:
		health_container.visible = false
	else:
		health_container.visible = true
		health_value_label.text = str(health)
		var progress_bar_value = (float(health) / float(character_info.max_health)) * 100.0
		health_progress_bar.value = int(progress_bar_value)


func update_selected_tags(abilities_to_check: Array[Ability], attacker_character: BattleCharacter = null):
	if health_container.visible == true:
		if attacker_character != null and get_depression_size() > 0 and not depression_assaulters.has(attacker_character):
			chain_tag.visible = true
		elif abilities_to_check.size() > 0:
			for ability in abilities_to_check:
				var ability_insecurity = Constants.get_matching_insecurity_for_ability_type(ability.type)
				var is_weak_to_ability = character_info.insecurity_weaknesses.has(ability_insecurity)
				weak_tag.visible = is_weak_to_ability
				break


func reset_selected_tags():
	weak_tag.visible = false
	chain_tag.visible = false


func damage(amount: int):
	health -= amount
	health = clamp(health, 0, character_info.max_health)
	_update_health_ui(true)
	_start_damage_dealt_animation(amount)


func _start_damage_dealt_animation(damage_dealt: int):
	damage_dealt_display.visible = true
	damage_dealt_display_value.text = str(damage_dealt)
	health_animation_player.play("damage_dealt_display_rise")
	await health_animation_player.animation_finished
	
	damage_dealt_display.visible = false
	health_animation_player.play("RESET")


func update_depression(character: BattleCharacter, ability: Ability):
	var ability_insecurity = Constants.get_matching_insecurity_for_ability_type(ability.type)
	if not character_info.insecurity_weaknesses.has(ability_insecurity): return
	
	if depression_assaulters.has(character):
		clear_depression()
	
	depression_assaulters.append(character)
	
	depression_ui.visible = true
	var color_rect = ColorRect.new()
	color_rect.color = Constants.get_insecurity_color(ability_insecurity)
	color_rect.custom_minimum_size.y = 20
	depression_container.add_child(color_rect) 


func clear_depression():
	depression_assaulters.clear()
	depression_ui.visible = false
	for child in depression_container.get_children():
		child.free()


func get_depression_size() -> int:
	return depression_assaulters.size()
