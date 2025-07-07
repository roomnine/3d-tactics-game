class_name TileLayout
extends Node

## Placeholder script that essentially replicates the Board's tile layout 
## into its own self-contained TileLayout class. 
## 
## This class can be made into a Resource Save utility for 
## instantiated boards, for instance. Alternatively, it 
## could pull the appropriate data from a board save and write back to it as needed.

#region Base Tile layout
## Tile Layout
var tile_layout: Dictionary
#endregion

## Initialize stats from a TileLayoutResource
func import_layout(layout: TileLayoutResource) -> void:
	tile_layout = layout.tile_layout
