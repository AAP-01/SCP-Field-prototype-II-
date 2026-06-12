extends Resource
class_name MultipleChoiceEventData

@export var event_text : String
@export var low_sanity_event_text : String
@export var difficulty : int	# From 1-10
@export var choices : Array[MultipleChoiceData]
@export var low_sanity_choices : Array[MultipleChoiceData]
@export var chosen_event_text : String
@export var chosen_choices : Array[MultipleChoiceData]	# chosen_choices is either choices or low_sanity_choices
