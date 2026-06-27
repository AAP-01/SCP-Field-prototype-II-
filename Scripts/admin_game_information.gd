extends VBoxContainer

@onready var difficulty: Label = $Difficulty

func _ready() -> void:
	difficulty.text = "Difficulty: " + SingletonPlayerStats.Difficulty.keys()[SingletonPlayerStats.difficulty]
