class_name Stats
extends Node

## Placeholder script that essentially replicates the Unit's Expertise Model 
## into its own self-contained Stats class. 
## 
## This class can be made into a Resource Save utility for 
## instantiated characters, for instance. Alternatively, it 
## could pull the appropriate data from a character save and write back to it as needed.

## Dictionary to store modifiers
var modifiers: Dictionary = {}
## Override name for the character
var override_name: String
## Status of the character
var status: String
## Current level of the character
var level: int = 1

#region Base Stats
## Movement Points (The radius the pawn can move)
var movement: int
## Jump height
var jump: int
## Maximum health
var max_health: int
## Current health
var curr_health: int
## Sprite path
var sprite: String
#endregion

#region Offensive Stats
## Attack power
var attack_power: int
## Attack range
var attack_range: int
#endregion

## Initialize stats from a StatsResource
func import_stats(stats: StatsResource) -> void:
	override_name = stats.override_name
	status = stats.status
	level = stats.level
	movement = stats.movement
	stats.set_jump()
	max_health = stats.max_health
	curr_health = max_health
	sprite = stats.sprite
	attack_power = stats.attack_power
	attack_range = stats.attack_range

## Provided a health operation as a parameter (e.g. "-2", "1"), adds the value to current health. As a consequence, this function serves for both damage and healing.
func apply_to_curr_health(new: int) -> void:
	print("Target initial health: ", curr_health, " - Applying damage: ", new)
	curr_health = clamp(curr_health + new, 0, max_health) # Apply health change and clamp to valid range
	print("Target final health: ", curr_health)
