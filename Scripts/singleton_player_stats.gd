extends Node
class_name PlayerStats

var health : int
var sanity : int
var advancement : int
var ammunition : int
var morale : int

enum Difficulty {EASY, NORMAL, HARD}
var difficulty : Difficulty
var event_difficulty : float
var health_cap : int
var sanity_cap : int
var advancement_cap : int
var ammunition_cap : int
var morale_cap : int
var low_sanity_threshold : int

func _ready() -> void:
	set_game_difficulty()

func set_game_difficulty() -> void:
	match difficulty:
		Difficulty.EASY:
			health = 100
			sanity = 100
			advancement = 0
			ammunition = 180
			morale = 100
			
			event_difficulty = 0.75
			health_cap = 100
			sanity_cap = 100
			advancement_cap = 15
			ammunition_cap = 330
			morale_cap = 100
			low_sanity_threshold = 10
		Difficulty.NORMAL:
			health = 90
			sanity = 90
			advancement = 0
			ammunition = 120
			morale = 90
			
			event_difficulty = 1
			health_cap = 100
			sanity_cap = 100
			advancement_cap = 20
			ammunition_cap = 180
			morale_cap = 100
			low_sanity_threshold = 30
		Difficulty.HARD:
			health = 75
			sanity = 75
			advancement = 0
			ammunition = 90
			morale = 75
			
			event_difficulty = 1.5
			health_cap = 90
			sanity_cap = 90
			advancement_cap = 30
			ammunition_cap = 120
			morale_cap = 90
			low_sanity_threshold = 45
			
func end_game() -> void:
	# Send to game over
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
	# Reach the advancement cap to win
	if advancement >= advancement_cap:	# Set the number to change the length of a game
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
