class_name BattleCharacter extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var character_selected_ui = $CharacterSelectedUI

var character_info: CharacterInfo
var facing_direction: Constants.FacingDirection


func init(character_info: CharacterInfo, facing_direction: Constants.FacingDirection):
	self.character_info = character_info
	self.facing_direction = facing_direction
	
	_init_sprite_2d()


func _init_sprite_2d():
	if facing_direction == Constants.FacingDirection.FORWARD:
		sprite_2d.texture = character_info.forward_facing_texture
	else:
		sprite_2d.texture = character_info.backward_facing_texture
	sprite_2d.scale = character_info.texture_scale
	
	var sprite_height = sprite_2d.texture.get_height()
	global_position.y -= (sprite_height * character_info.texture_scale.y) / 2.0


func set_as_selected(selected: bool):
	character_selected_ui.visible = selected
