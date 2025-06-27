class_name UiService
extends RefCounted
## Service class for managing UI-related functions

## Reference to ControlsResource
var controls: ControlsResource


## Initializes the UiService with Controls Resource
func _init(_controls: ControlsResource) -> void:
	controls = _controls


## TODO: Update Controller Hints
## func update_controller_hints()


## Set actions menu visibility and update action button states
func set_actions_menu_visibility(v: bool, unit: DefaultUnit, control: TacticsControls) -> void:
	if not control.get_node("Actions").visible:
		control.get_node("Actions/Move").grab_focus() # Focus on Move action if menu isn't visible
	
	control.get_node("Actions").visible = v and unit.can_act()
	
	if not unit:
		return # Exit if no unit is provided
	
	# Update action button states based on unit cap
	control.get_node("Actions/Move").disabled = not unit.res.can_move
	control.get_node("Actions/Attack").disabled = not unit.res.can_attack
