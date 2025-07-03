class_name TileEffectManager
extends Node

var tile_effects: Dictionary = {}

func add_tile_effect(tile: Tile, effect: TileEffectResource) -> void:
	var id = tile.get_instance_id()
	if not tile_effects.has(id):
		tile_effects[id] = []
	if effect not in tile_effects[id]:
		tile_effects[id].append(effect)

func remove_tile_effect(tile: Tile, effect: TileEffectResource) -> void:
	var id = tile.get_instance_id()
	if tile_effects.has(id):
		tile_effects[id].erase(effect)
		if tile_effects[id].is_empty():
			tile_effects.erase(id)

func get_tile_effects(tile: Tile) -> Array[TileEffectResource]:
	return tile_effects.get(tile.get_instance_id(), [])
