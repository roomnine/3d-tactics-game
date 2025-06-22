class_name InputCapture
extends Node3D

@export var res: InputCaptureResource = preload("res://data/models/view/ui/input_capture.tres")
var serv: InputCaptureService

var debug_ray_mesh: MeshInstance3D


func _ready() -> void:
	serv = InputCaptureService.new(res)
	debug_ray_mesh = serv.setup_debug_ray(self)


func _input(event: InputEvent) -> void:
	serv.process_input(event)


func _process(_delta: float) -> void:
	# Continuous ray casting for debugging
	project_mouse_position(1, false)  # Adjust collision mask as needed


func _unhandled_input(event: InputEvent) -> void:
	serv.handle_input(event)


func project_mouse_position(collision_mask: int, is_joystick: bool) -> Dictionary:
	return serv.project_mouse_position(collision_mask, is_joystick, self)
