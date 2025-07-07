class_name ControlsInputService
extends RefCounted
## Service class for managing input-related functionalities in the Tactics game.

## Reference to the TacticsControlsResource.
var controls: ControlsResource
## Node for capturing mouse clicks.
var input_capture: Node3D


## Initializes the TacticsControlsInputService with necessary resources and nodes.
func _init(_controls: ControlsResource, _input_capture: Node) -> void:
	controls = _controls
	input_capture = _input_capture


## Updates the mouse mode based on whether a joystick is being used.
func update_mouse_mode() -> void:
	Input.set_mouse_mode(int(controls.is_joystick))


## Handles input events and updates the joystick status.
func handle_input(event: InputEvent) -> void:
	controls.is_joystick = event is InputEventJoypadButton or event is InputEventJoypadMotion


## Gets the 3D position of the mouse in the game world.
## Returns null if hovering over a UI element or if input_capture is not set.
func get_3d_canvas_mouse_position(collision_mask: int, ctrl: TacticsControls) -> Object:
	if is_mouse_hovering_ui_elem(ctrl):
		return null
	
	if input_capture:
		return input_capture.project_mouse_position(collision_mask, controls.is_joystick)
	else:
		push_error("InputCapture node not found")
		return null


## Checks if the mouse is hovering over a UI element.
## Returns true if the mouse is over any of the specified UI elements.
func is_mouse_hovering_ui_elem(ctrl: TacticsControls, elm: Array[String] = TacticsConfig.ui_elem) -> bool:
	for e: String in elm:
		var node = ctrl.get_node_or_null(e)
		if node and node.visible:
			match e:
				"Actions":  # <- Use correct relative path here
					for action: Button in node.get_children():
						if action.get_global_rect().has_point(ctrl.get_viewport().get_mouse_position()):
							return true
	return false
