extends Resource
class_name MultipleChoiceData

@export var choice_text : String
@export var success_rate : int	# From 1-100
@export var random : bool
@export var ammunition_change : int
@export var outcomes : Array[OutcomeData]
