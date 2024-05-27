extends Node

const INSECURITY_TEXTURES = preload("res://common/insecurities/insecurity_textures.tres")

enum Insecurity {
	NORMAL,
	APPEARANCE,
	SELF_ESTEEM,
	INTELLIGENCE,
	PHYSICAL_ABILITY,
	SOCIAL_LIFE
}

enum FacingDirection {
	FORWARD_LEFT,
	FORWARD_RIGHT,
	BACKWARD_LEFT,
	BACKWARD_RIGHT,
}

enum InsecurityAffinityType { 
	NONE,
	WEAK,
	BLOCK,
	HEAL,
	DEFLECT
}

enum AbilityType {
	NORMAL_ATTACK,
	APPEARANCE_ATTACK,
	SELF_ESTEEM_ATTACK,
	INTELLIGENCE_ATTACK,
	PHYSICAL_ABILITY_ATTACK,
	SOCIAL_LIFE_ATTACK,
	EFFECT,
	HEALING,
	SUPPORT,
	PASSIVE
}


func get_insecurity_color(insecurity: Insecurity) -> Color:
	match (insecurity):
		Insecurity.NORMAL:
			return INSECURITY_TEXTURES.normal_color
		Insecurity.APPEARANCE:
			return INSECURITY_TEXTURES.appearance_color
		Insecurity.SELF_ESTEEM:
			return INSECURITY_TEXTURES.self_esteem_color
		Insecurity.INTELLIGENCE:
			return INSECURITY_TEXTURES.intelligence_color
		Insecurity.PHYSICAL_ABILITY:
			return INSECURITY_TEXTURES.physical_ability_color
		Insecurity.SOCIAL_LIFE:
			return INSECURITY_TEXTURES.social_life_color
	
	return Color.WHITE


func get_insecurity_icon(insecurity_affinity_type: InsecurityAffinityType = InsecurityAffinityType.NONE) -> Texture2D:
	match insecurity_affinity_type:
		InsecurityAffinityType.WEAK:
			return INSECURITY_TEXTURES.weak_insecurity_affinity_icon
		InsecurityAffinityType.BLOCK:
			return INSECURITY_TEXTURES.block_insecurity_affinity_icon
		InsecurityAffinityType.HEAL:
			return INSECURITY_TEXTURES.heal_insecurity_affinity_icon
		InsecurityAffinityType.DEFLECT:
			return INSECURITY_TEXTURES.deflect_insecurity_affinity_icon
	
	return INSECURITY_TEXTURES.insecurity_icon
