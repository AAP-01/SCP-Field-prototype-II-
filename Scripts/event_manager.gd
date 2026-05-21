extends Node
class_name EventManager

@onready var event_text: Label = $"../../Event/Event Text"
var event
var choices : Array[Button]

# Set up the first event upon starting
func _ready() -> void:
	choices.append($"../../Event/VBoxContainer/Choice 1")	# 0
	choices.append($"../../Event/VBoxContainer/Choice 2")	# 1
	choices.append($"../../Event/VBoxContainer/Choice 3")	# 2
	choices.append($"../../Event/VBoxContainer/Choice 4")	# 3
	
	select_event()
	display_event()
	
func select_event() -> void:
	event = EventList.events[randi_range(0, EventList.events.size() - 1)]
	
func display_event() -> void:
	event_text.text = event.event_text
	print("Event selected: " + event.resource_path.get_file())
	
	var index = 0
	if event is MultipleChoiceEventData:
		for i in range(event.choices.size()):
			choices[index].text = event.choices[index].choice_text
			index += 1
	elif event is OneChoiceEventData:
		choices[0].text = event.choice.outcome_text
		choices[1].hide()
		choices[2].hide()
		choices[3].hide()
