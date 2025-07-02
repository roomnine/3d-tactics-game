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
	if not control.get_node("ControlArea").visible:
		control.get_node("ControlArea/ActionArea/BasicActions/Move").grab_focus() # Focus on Move action if menu isn't visible
	
	control.get_node("ControlArea").visible = v and unit.can_act()
	
	if not unit:
		return # Exit if no unit is provided
	
	# Skills container
	var skills_list = control.get_node("ControlArea/ActionArea/SkillActions")
	
	# Clear old buttons
	for child in skills_list.get_children():
		child.queue_free()
	
	# Add a button for each skill
	for skill in unit.skills.get_all_skills():
		var btn = Button.new()
		btn.text = skill.name
		btn.tooltip_text = skill.description
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.connect("button_down", Callable(control, "_player_wants_to_use_skill").bind(skill))
		skills_list.add_child(btn)

	# Update action button states based on unit cap
	control.get_node("ControlArea/ActionArea/BasicActions/Move").disabled = not unit.res.can_move
	control.get_node("ControlArea/ActionArea/BasicActions/Attack").disabled = not unit.res.can_attack
	
	# TODO: update skills button states based on unit cap (i.e. energy)
