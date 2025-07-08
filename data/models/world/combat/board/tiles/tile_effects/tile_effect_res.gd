class_name TileEffectResource
extends Resource
## Effects of a tile effect

## Terrain effect type
enum EffectType {
	NONE,
	OBSTRUCTIVE
	#TODO: OCCLUDING
	#TODO: LAVA
}

## Basic info regarding effect
@export var name: String
@export var description: String
@export var effect_type: EffectType = EffectType.NONE
@export var effect_magnitude: int = 0
@export var is_victory_tile: bool = false
