extends Node

const INSECURITY_TEXTURES = preload("res://common/insecurities/insecurity_textures.tres")
const ABILITY_TEXTURES = preload("res://characters/abilities/textures/ability_textures.tres")

enum Insecurity {
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
	STRONG,
	BLOCK,
	HEAL,
	DEFLECT
}

enum AbilityType {
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

enum AttackLandType {
	MISS,
	HIT,
	WEAK,
	CHAIN,
	CRITICAL
}

enum CharacterSelectState {
	NONE,
	PLAYER_SELECT,
	PLAYER_SELECTED,
	PLAYER_TARGET,
	PLAYER_TARGETED,
	ENEMY_SELECT,
	ENEMY_SELECTED,
	ENEMY_TARGET,
	ENEMY_TARGETED
}


func get_insecurity_color(insecurity: Insecurity) -> Color:
	match (insecurity):
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
		InsecurityAffinityType.STRONG:
			return INSECURITY_TEXTURES.strong_insecurity_affinity_icon
		InsecurityAffinityType.BLOCK:
			return INSECURITY_TEXTURES.block_insecurity_affinity_icon
		InsecurityAffinityType.HEAL:
			return INSECURITY_TEXTURES.heal_insecurity_affinity_icon
		InsecurityAffinityType.DEFLECT:
			return INSECURITY_TEXTURES.deflect_insecurity_affinity_icon
	
	return INSECURITY_TEXTURES.insecurity_icon


func get_ability_type_color(ability_type: AbilityType) -> Color:
	match (ability_type):
		AbilityType.APPEARANCE_ATTACK:
			return INSECURITY_TEXTURES.appearance_color
		AbilityType.SELF_ESTEEM_ATTACK:
			return INSECURITY_TEXTURES.self_esteem_color
		AbilityType.INTELLIGENCE_ATTACK:
			return INSECURITY_TEXTURES.intelligence_color
		AbilityType.PHYSICAL_ABILITY_ATTACK:
			return INSECURITY_TEXTURES.physical_ability_color
		AbilityType.SOCIAL_LIFE_ATTACK:
			return INSECURITY_TEXTURES.social_life_color
		AbilityType.EFFECT:
			return ABILITY_TEXTURES.effect_color
		AbilityType.HEALING:
			return ABILITY_TEXTURES.healing_color
		AbilityType.SUPPORT:
			return ABILITY_TEXTURES.support_color
		AbilityType.PASSIVE:
			return ABILITY_TEXTURES.passive_color
	
	return Color.WHITE


func get_ability_type_icon(ability_type: AbilityType) -> Texture2D:
	match ability_type:
		AbilityType.APPEARANCE_ATTACK:
			return ABILITY_TEXTURES.appearance_texture
		AbilityType.SELF_ESTEEM_ATTACK:
			return ABILITY_TEXTURES.self_esteem_texture
		AbilityType.INTELLIGENCE_ATTACK:
			return ABILITY_TEXTURES.intelligence_texture
		AbilityType.PHYSICAL_ABILITY_ATTACK:
			return ABILITY_TEXTURES.physical_ability_texture
		AbilityType.SOCIAL_LIFE_ATTACK:
			return ABILITY_TEXTURES.social_life_texture
		AbilityType.EFFECT:
			return ABILITY_TEXTURES.effect_texture
		AbilityType.HEALING:
			return ABILITY_TEXTURES.healing_texture
		AbilityType.SUPPORT:
			return ABILITY_TEXTURES.support_texture
		AbilityType.PASSIVE:
			return ABILITY_TEXTURES.passive_texture
	
	return ABILITY_TEXTURES.appearance_texture


func get_matching_ability_type_for_insecurity(insecurity: Insecurity) -> AbilityType:
	match insecurity:
		Insecurity.APPEARANCE:
			return AbilityType.APPEARANCE_ATTACK
		Insecurity.SELF_ESTEEM:
			return AbilityType.SELF_ESTEEM_ATTACK
		Insecurity.INTELLIGENCE:
			return AbilityType.INTELLIGENCE_ATTACK
		Insecurity.PHYSICAL_ABILITY:
			return AbilityType.PHYSICAL_ABILITY_ATTACK
		Insecurity.SOCIAL_LIFE:
			return AbilityType.SOCIAL_LIFE_ATTACK
	return -1


func get_matching_insecurity_for_ability_type(ability_type: AbilityType) -> Insecurity:
	match ability_type:
		AbilityType.APPEARANCE_ATTACK:
			return Insecurity.APPEARANCE
		AbilityType.SELF_ESTEEM_ATTACK:
			return Insecurity.SELF_ESTEEM
		AbilityType.INTELLIGENCE_ATTACK:
			return Insecurity.INTELLIGENCE
		AbilityType.PHYSICAL_ABILITY_ATTACK:
			return Insecurity.PHYSICAL_ABILITY
		AbilityType.SOCIAL_LIFE_ATTACK:
			return Insecurity.SOCIAL_LIFE
	return -1
	
