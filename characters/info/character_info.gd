class_name CharacterInfo extends Resource

@export_group("Visuals")
@export var forward_facing_texture: Texture2D
@export var backward_facing_texture: Texture2D
@export var texture_scale: Vector2
@export_group("Insecurity Affinities")
@export var insecurity_weaknesses: Array[Constants.Insecurity]
@export_group("Stats")
@export var max_health: int
