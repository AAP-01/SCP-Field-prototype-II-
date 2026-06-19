extends VBoxContainer

@onready var resource_name: Label = $"Resource name"
@onready var resource_type: Label = $"Resource type"
@onready var sanity_modifier: Label = $"Sanity Modifier"

@onready var event_manager: EventManager = $"../../../../../../Managers/Event Manager"

func _ready() -> void:
	event_manager.event_selected.connect(_on_admin_panel_event_selected)
	
	# For resource_name
	resource_name.text = "Resource name: " + SingletonEvent.event.resource_path.get_file()
	
	# For resource_name
	if SingletonEvent.event is MultipleChoiceEventData:
		resource_type.text = "Resource type: MultipleChoiceEventData"
	elif SingletonEvent.event is OneChoiceEventData:
		resource_type.text = "Resource type: OneChoiceEventData"
		
	# For sanity_modifer
	if SingletonEvent.event is MultipleChoiceEventData:
		if SingletonPlayerStats.sanity >= 30:
			sanity_modifier.text = "Sanity modifier: normal"
		else:
			sanity_modifier.text = "Sanity modifier: low"
	elif SingletonEvent.event is OneChoiceEventData:
		sanity_modifier.text = "Sanity modifier: null"
	
# Runs when event_selected, when a new event is selected, from Event Manager emits
func _on_admin_panel_event_selected() -> void:
	resource_name.text = "Resource name: " + SingletonEvent.event.resource_path.get_file()
	
	# For sanity_modifier
	if SingletonEvent.event is MultipleChoiceEventData:
		if SingletonPlayerStats.sanity >= 30:
			sanity_modifier.text = "Sanity modifier: normal"
		else:
			sanity_modifier.text = "Sanity modifier: low"
	elif SingletonEvent.event is OneChoiceEventData:
		sanity_modifier.text = "Sanity modifier: null"
		
	# For resource_type
	if SingletonEvent.event is MultipleChoiceEventData:
		resource_type.text = "Resource type: MultipleChoiceEventData"
	elif SingletonEvent.event is OneChoiceEventData:
		resource_type.text = "Resource type: OneChoiceEventData"
