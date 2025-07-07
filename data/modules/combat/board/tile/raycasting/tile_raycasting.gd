class_name TileRaycasting
extends Node3D
## Handles raycasting operations for Tile.
##
## This class is responsible for detecting neighboring tiles and objects above the tile.
## It is typically instantiated as a child of Tile.


#region: --- Methods ---
## Returns all the neighbouring tiles within a given height range.
## [param height] The maximum height difference to consider for neighbors.
## [returns] An array of neighboring Node3D objects (typically Tiles).

func get_neighboring_tiles(height: float) -> Array[Node3D]:
	var neighboring_tiles: Array[Node3D] = []
	
	for ray: RayCast3D in $Neighbors.get_children() as Array[RayCast3D]:
		var obj: Node3D = ray.get_collider() # Get object hit by ray
		
		## Check if object is Tile
		if obj and obj is Tile:
			# Check if object exists and is within the specified height range
			if (obj and abs(obj.global_position.y - get_parent().global_position.y) <= height):
				neighboring_tiles.append(obj) # Add object to neighboring tiles list
			
	return neighboring_tiles
	
## Returns the object directly above the tile.
## [returns] The object above the tile, or null if none found.
func get_object_above() -> Object:
	return $Above.get_collider() # Return object hit by the upward-facing ray
#endregion
