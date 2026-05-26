extends Node
class_name PlayerManager

static var health = 100
static var sanity = 100
static var advancement = 0

func change_stats() -> void:
	pass

func _on_event_manager_choice_selected(outcome: Resource) -> void:
	health += outcome.health_change
	health = clamp(health, 0, 100)
	
	sanity += outcome.sanity_change
	sanity = clamp(sanity, 0, 100)
	
	advancement += outcome.advancement
	
	print("	Health change: " + str(outcome.health_change) + ", Current health: " + str(health))
	print("	Sanity change: " + str(outcome.sanity_change) + ", Current sanity: " + str(sanity))
	print("	Advancement: " + str(outcome.advancement) + ", Current advancement: " + str(advancement))
	print("=====")
	
	# Send to game over
	if health <= 0:
		pass
		
	# Weaken success rate
	if sanity <= 0:
		pass
		
	# Hit the number to win
	if advancement >= 20:	# Set the number to change the length of a game
		pass
