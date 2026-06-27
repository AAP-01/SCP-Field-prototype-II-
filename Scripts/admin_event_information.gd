extends VBoxContainer

@onready var resource_name: Label = $"Resource name"
@onready var resource_type: Label = $"Resource type"
@onready var sanity_modifier: Label = $"Sanity Modifier"
@onready var choice_selected: Label = $"Choice Selected"
@onready var success: Label = $Success

@onready var event_manager: EventManager = $"../../../../../../Managers/Event Manager"

func _ready() -> void:
	event_manager.event_selected.connect(_on_admin_panel_event_selected)
	event_manager.choice_selected_admin.connect(_on_admin_panel_event_selected)
	event_manager.choice_selected_admin.connect(check_success)
	
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
		sanity_modifier.text = "Sanity modifier: N/A"
		
	# For choice_selected
	choice_selected.text = "Choice selected: N/A"
	
	# For success
	success.text = "Success: N/A"
	
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
		sanity_modifier.text = "Sanity modifier: N/A"
		
	# For resource_type
	if SingletonEvent.event is MultipleChoiceEventData:
		resource_type.text = "Resource type: MultipleChoiceEventData"
	elif SingletonEvent.event is OneChoiceEventData:
		resource_type.text = "Resource type: OneChoiceEventData"
		
	# For choice_selected
	if SingletonEvent.choice_selected is MultipleChoiceData:
		choice_selected.text = "Choice selected: " + SingletonEvent.choice_selected.choice_text
	elif SingletonEvent.choice_selected is OneChoiceData:
		choice_selected.text = "Choice selected: " + SingletonEvent.choice_selected.outcome_text
	
func check_success() -> void:
	# For success
	if SingletonEvent.choice_selected is MultipleChoiceData:
		if SingletonEvent.choice_selected.success_rate == 100:
			success.text = "Success: N/A"
		elif SingletonEvent.success:
			success.text = "Success: true"
		else:
			success.text = "Success: false"
	elif SingletonEvent.choice_selected is OneChoiceData:
		success.text = "Success: N/A"
