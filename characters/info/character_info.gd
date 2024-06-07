class_name CharacterInfo extends Resource

@export_group("Info")
@export var name: String
@export_group("Visuals")
@export var icon_texture: Texture2D
@export var forward_facing_texture: Texture2D
@export var backward_facing_texture: Texture2D
@export var texture_scale: Vector2
@export_group("Insecurity Affinities")
@export var insecurity_weaknesses: Array[Constants.Insecurity]
@export var insecurity_strengths: Array[Constants.Insecurity]
@export var insecurity_blocks: Array[Constants.Insecurity]
@export var insecurity_heals: Array[Constants.Insecurity]
@export var insecurity_deflects: Array[Constants.Insecurity]
@export_group("Stats")
@export var max_health: int
@export_group("Abilities")
@export var abilities: Array[Ability]


const FEAR_IGNORE_CHANCE = 0.7
