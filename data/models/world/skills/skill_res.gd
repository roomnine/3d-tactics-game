class_name SkillResource
extends Resource

## Different skill types
enum SkillType {
	TARGET_UNIT,
	TARGET_TILE,
	NO_TARGET
}

## Primary skill effect
enum PrimaryEffect {
	NONE,
	DAMAGE,
	#TODO: HEAL
}

## Secondary skill effect
enum SecondaryEffect {
	NONE,
	KNOCKBACK
	#TODO: BURN
}

## Basic info
@export var name: String
@export var description: String
@export var icon: Texture
@export var energy_cost: int = 0

## Category & Targeting
@export var skill_type: SkillType = SkillType.TARGET_UNIT
@export var range: float = 0.0
@export var area_radius: float = 0.0
@export var friendly_fire: bool = false
@export var self_inflicting: bool = false

## Primary effect
@export var primary_effect: PrimaryEffect = PrimaryEffect.DAMAGE
@export var primary_effect_amount: int = 0

## Secondary effect
@export var secondary_effect: SecondaryEffect = SecondaryEffect.NONE
@export var secondary_effect_amount: int = 0
