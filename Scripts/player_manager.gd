extends Node
class_name PlayerManager

signal change_ui
signal stat_changed

@onready var health_amount: Label = $"../../Stat Bars/Health/Health Amount"
@onready var sanity_amount: Label = $"../../Stat Bars/Sanity/Sanity Amount"
@onready var ammunition_amount: Label = $"../../Stat Bars/Ammunition/Ammunition Amount"
@onready var morale_amount: Label = $"../../Stat Bars/Morale/Morale Amount"

var penalty = 1

func _ready() -> void:	# Reset the stats to default upon starting a game
	stat_changed.connect(SingletonPlayerStats.end_game)
	penalty = 1

func _on_event_manager_choice_selected(outcome: Resource) -> void:	# "outcome" should only be OutcomeData or OneChoiceData (for now)
	if outcome.ammunition_change < 0:	# Only run if the player runs out of ammunition
		check_ammo(outcome)
	
	# Calculate new health
	SingletonPlayerStats.health = clamp(SingletonPlayerStats.health + outcome.health_change * penalty, 0, SingletonPlayerStats.health_cap)
	
	# Calculate new sanity
	SingletonPlayerStats.sanity = clamp(SingletonPlayerStats.sanity + outcome.sanity_change, 0, SingletonPlayerStats.sanity_cap)
	
	# Calculate new advancement
	SingletonPlayerStats.advancement += outcome.advancement
	
	# Calculate new ammunition
	SingletonPlayerStats.ammunition = clamp(SingletonPlayerStats.ammunition + outcome.ammunition_change, 0, SingletonPlayerStats.ammunition_cap)
	
	# Calculate new morale
	SingletonPlayerStats.morale = clamp(SingletonPlayerStats.morale + outcome.morale_change * penalty, 0, SingletonPlayerStats.morale_cap)
	
	# Update UI
	change_ui.emit()	# Signal to Stat Bars to update the HUD
	
	# For console
	print("	Health change: " + str(outcome.health_change) + ", Current health: " + str(SingletonPlayerStats.health))
	print("	Sanity change: " + str(outcome.sanity_change) + ", Current sanity: " + str(SingletonPlayerStats.sanity))
	print("	Advancement: " + str(outcome.advancement) + ", Current advancement: " + str(SingletonPlayerStats.advancement))
	print("	Ammunition change: " + str(outcome.ammunition_change) + ", Current ammunition: " + str(SingletonPlayerStats.ammunition))
	print("	Morale change: " + str(outcome.morale_change) + ", Current morale: " + str(SingletonPlayerStats.morale))
	print("=====")
	stat_changed.emit()	# Signal to show_outcome(index, event) in Event Manager to show the outcome after editing the stats
	
	## Send to game over
	#if SingletonPlayerStats.health <= 0:
		#get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
	## Reach the number to win
	#if SingletonPlayerStats.advancement >= SingletonPlayerStats.advancement_cap:	# Set the number to change the length of a game
		#get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func check_ammo(outcome : Resource) -> void:
	if outcome is OutcomeData:	# Focuses on penalizing success rate of the selected choice
		pass	# Do nothing because it's already done in Event Manager
	elif outcome is OneChoiceData:	# Focuses on penalizing stat modifications instead of success rate since OneChoiceData choices are guaranteed
		var remaining_ammunition = abs(SingletonPlayerStats.ammunition - outcome.ammunition_change) - 5	# First 5 missing rounds don't matter
		
		# Determine the gain/loss penalty severity based on ammount of ammunition missing
		match outcome.status:
			"gain":
				for i in range(remaining_ammunition):
					penalty -= 0.05	# Multiplying a positive number with 0.XX to reduce gain
			"loss":
				for i in range(remaining_ammunition):
					penalty += 0.05	# Multiplying a negative number with 1.XX to increase loss
			_:
				print("UNKNOWN STATUS")
