class_name UnitHudService
extends RefCounted
## Service class that manages HUD for a unit

## Update health display
##
## @param unit: DefaultUnit to display health above
func update_unit_health(unit: DefaultUnit) -> void:
	var _health_label: Label3D = unit.get_node("DefaultUnitSprite/CharacterUI/HealthLabel")
	_health_label.text = str(unit.stats.curr_health) + "/" + str(unit.stats.max_health)


## Apply sprite tint when unable to act
##
## @param unit: DefaultUnit to apply tint to
func apply_tint_when_unable_to_act(unit: DefaultUnit) -> void:
	var mesh_instance = unit.get_node("DefaultUnitSprite")

	var material = mesh_instance.get_active_material(0)
	if not material:
		push_error("Mesh has no active material!")
		return

	# Only duplicate if not yet overridden
	if not mesh_instance.get_surface_override_material(0):
		material = material.duplicate()
		mesh_instance.set_surface_override_material(0, material)

	if material is StandardMaterial3D and not unit.can_act():
		material.albedo_color = Color(0.411765, 0.411765, 0.411765, 1)
	else:
		material.albedo_color = unit.stats.default_color
