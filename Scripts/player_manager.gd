extends Node
class_name PlayerManager

@onready var health_amount: Label = $"../../Stat Bars/Health/Health Amount"
@onready var sanity_amount: Label = $"../../Stat Bars/Sanity/Sanity Amount"
@onready var ammunition_amount: Label = $"../../Stat Bars/Ammunition/Ammunition Amount"
@onready var morale_amount: Label = $"../../Stat Bars/Morale/Morale Amount"

static var health = 100
static var sanity = 100
static var advancement = 0
static var ammunition = 180
static var morale = 100
var penalty = 1

signal stats_changed

func _ready() -> void:	# Reset the stats to default upon starting a game
	health = 100
	sanity = 100
	advancement = 0
	ammunition = 180
	morale = 100
	penalty = 1

func _on_event_manager_choice_selected(outcome: Resource) -> void:	# "outcome" should only be OutcomeData or OneChoiceData (for now)
	if outcome.ammunition_change < 0:	# Only run if the player runs out of ammunition
		check_ammo(outcome)
	
	# Calculate new health
	health += outcome.health_change * penalty
	health = clamp(health, 0, 100)
	
	# Calculate new sanity
	sanity += outcome.sanity_change
	sanity = clamp(sanity, 0, 100)
	
	# Calculate new advancement
	advancement += outcome.advancement
	
	# Calculate new ammunition
	ammunition += outcome.ammunition_change
	ammunition = clamp(ammunition, 0, 330)
	
	# Calculate new morale
	morale += outcome.morale_change * penalty
	morale = clamp(morale, 0, 100)
	
	# Update UI
	health_amount.text = str(health) + "/100"
	sanity_amount.text = str(sanity) + "/100"
	ammunition_amount.text = str(ammunition) + "/330"
	morale_amount.text = str(morale) + "/100"
	
	# For console
	print("	Health change: " + str(outcome.health_change) + ", Current health: " + str(health))
	print("	Sanity change: " + str(outcome.sanity_change) + ", Current sanity: " + str(sanity))
	print("	Advancement: " + str(outcome.advancement) + ", Current advancement: " + str(advancement))
	print("	Ammunition change: " + str(outcome.ammunition_change) + ", Current ammunition: " + str(ammunition))
	print("	Morale change: " + str(outcome.morale_change) + ", Current morale: " + str(morale))
	print("=====")
	stats_changed.emit()
	
	# Send to game over
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
	# Reach the number to win
	if advancement >= 20:	# Set the number to change the length of a game
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func check_ammo(outcome : Resource) -> void:
	if outcome is OutcomeData:	# Focuses on penalizing success rate of the selected choice
		pass	# Do nothing because it's already done in Event Manager
	elif outcome is OneChoiceData:	# Focuses on penalizing stat modifications instead of success rate since OneChoiceData choices are guaranteed
		var remaining_ammunition = abs(PlayerManager.ammunition - outcome.ammunition_change) - 5	# First 5 missing rounds don't matter
		
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
