class_name BattleCharacter extends Sprite2D

var character_info: CharacterInfo
var facing_direction: Constants.FacingDirection


func init(character_info: CharacterInfo, facing_direction: Constants.FacingDirection):
	self.character_info = character_info
	self.facing_direction = facing_direction
	
	if facing_direction == Constants.FacingDirection.FORWARD:
		texture = character_info.forward_facing_texture
	else:
		texture = character_info.backward_facing_texture
	scale = character_info.texture_scale
