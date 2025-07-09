class_name GetTileIndexFromName
extends Node
## Utility methods for getting tile index from name

static func get_tile_index_from_name(tile_name: String) -> int:
	var regex := RegEx.new()
	var pattern := r"^Tile(\d+)$"
	var result := regex.compile(pattern)
	if result != OK:
		push_error("Failed to compile regex pattern: " + pattern)
		return -1

	var match := regex.search(tile_name)
	if match:
		return match.get_string(1).to_int()
	
	push_warning("Tile name '%s' does not match expected pattern." % tile_name)
	return -1
