class_name TacticsConfig
extends Node3D
## Tactics system configuration.
##
## This class contains static properties and methods for configuring various aspects
## of the tactics system, including colors, materials, unit properties, and view settings.

#region: --- Props ---
## Dictionary of color codes used in the tactics system.
static var color: Dictionary = {
	"white": "FFFFFF3F", # Semi-transparent white
	"blue_cola": "008fdbBF", # Semi-transparent blue cola color
	"blue_bolt": "0aa9ffBF", # Semi-transparent blue bolt color
	"rosso_corsa": "d10000BF", # Semi-transparent rosso corsa (racing red) color
	"coral_red": "ff4242BF", # Semi-transparent coral red color
}

## Dictionary of materials used for different states in the tactics system.
static var mat_color: Dictionary = {
	"hover": create_material(str(color.white)),
	"reachable": create_material(str(color.blue_cola)),
	"reachable_hover": create_material(str(color.blue_bolt)),
	"attackable": create_material(str(color.rosso_corsa)),
	"hover_attackable": create_material(str(color.coral_red)),
}

## Dictionary of unit-related configuration values.
static var unit: Dictionary = {
	"base_walk_speed": 8, ## Base speed for unit movement on the board
	"animation_frames": 1, ## Number of frames for unit animations
	"min_height_to_jump": 1, ## The tile height from which we use JUMP unit animation
	"gravity_strength": 6, ## Force of gravity used in jump & fall physics
	"min_time_for_attack": 1, ## Minimum time required for an attack action
}

## Dictionary of view-related configuration values.
static var view: Dictionary = {
	"default_t_cam_zoom": 30, ## The default FOV for tactics camera node
}

## Array of UI element names used to filter out UI elements when parsing the mouse cursor position.
static var ui_elem: Array[String] = [
	"%Actions", "%Hints",
]
#endregion

## Creates a StandardMaterial3D with specified color, texture, and shading mode.
##
## @param color_hex: The color of the material in hexadecimal format.
## @param texture: The albedo texture for the material (optional).
## @param shaded_mode: The shading mode for the material (default: BaseMaterial3D.SHADING_MODE_PER_PIXEL).
## @return: A new StandardMaterial3D instance with the specified properties.
static func create_material(color_hex: Variant, texture: Texture2D = null, shaded_mode: BaseMaterial3D.ShadingMode = BaseMaterial3D.SHADING_MODE_PER_PIXEL) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA # Set material to use alpha transparency
	material.albedo_color = Color(str(color_hex)) # Set the material color
	material.albedo_texture = texture # Set the albedo texture (if provided)
	material.shading_mode = shaded_mode # Set the shading mode
	return material
