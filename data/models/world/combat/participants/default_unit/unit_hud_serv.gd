class_name UnitHudService
extends RefCounted
## Service class that manages HUD for a unit

## Update health display
##
## @param unit: DefaultUnit to display health above
func update_unit_health(unit: DefaultUnit) -> void:
	pass

## Apply sprite tint when unable to act
##
## @param unit: DefaultUnit to apply tint to
func apply_tint_when_unable_to_act(unit: DefaultUnit) -> void:
	pass
