extends VBoxContainer

# In Player Stats
@onready var health: Label = $Health
@onready var sanity: Label = $Sanity
@onready var advancement: Label = $Advancement
@onready var ammunition: Label = $Ammunition
@onready var morale: Label = $Morale

# For Stat Bars in main_game.tscn
@onready var health_amount: Label = $"../../../../../../Stat Bars/Health/Health Amount"
@onready var sanity_amount: Label = $"../../../../../../Stat Bars/Sanity/Sanity Amount"
@onready var ammunition_amount: Label = $"../../../../../../Stat Bars/Ammunition/Ammunition Amount"
@onready var morale_amount: Label = $"../../../../../../Stat Bars/Morale/Morale Amount"

# Sent from signals in Player Stats
func _ready() -> void:
	health.text = "Health: " + str(SingletonPlayerStats.health)
	sanity.text = "Sanity: " + str(SingletonPlayerStats.sanity)
	advancement.text = "Advancement: " + str(SingletonPlayerStats.advancement)
	ammunition.text = "Ammunition: " + str(SingletonPlayerStats.ammunition)
	morale.text = "Morale: " + str(SingletonPlayerStats.morale)

func _on_health_input_text_submitted(new_text: String) -> void:
	var value = clamp(new_text.to_int(), 0, SingletonPlayerStats.health_cap)
	health.text = "Health: " + str(value)
	SingletonPlayerStats.health = value
	health_amount.text = str(SingletonPlayerStats.health) + "/" + str(SingletonPlayerStats.health_cap)

func _on_sanity_input_text_submitted(new_text: String) -> void:
	var value = clamp(new_text.to_int(), 0, SingletonPlayerStats.sanity_cap)
	sanity.text = "Sanity: " + str(value)
	SingletonPlayerStats.sanity = value
	sanity_amount.text = str(SingletonPlayerStats.sanity) + "/" + str(SingletonPlayerStats.sanity_cap)

func _on_advancement_input_text_submitted(new_text: String) -> void:
	var value = clamp(new_text.to_int(), 0, SingletonPlayerStats.advancement_cap)
	advancement.text = "Advancement: " + str(value)
	SingletonPlayerStats.advancement = value

func _on_ammunition_input_text_submitted(new_text: String) -> void:
	var value = clamp(new_text.to_int(), 0, SingletonPlayerStats.ammunition_cap)
	ammunition.text = "Ammunition: " + str(value)
	SingletonPlayerStats.ammunition = value
	ammunition_amount.text = str(SingletonPlayerStats.ammunition) + "/" + str(SingletonPlayerStats.ammunition_cap)

func _on_morale_input_text_submitted(new_text: String) -> void:
	var value = clamp(new_text.to_int(), 0, SingletonPlayerStats.morale_cap)
	morale.text = "Morale: " + str(value)
	SingletonPlayerStats.morale = value
	morale_amount.text = str(SingletonPlayerStats.morale) + "/" + str(SingletonPlayerStats.morale_cap)
