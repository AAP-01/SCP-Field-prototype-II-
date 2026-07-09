extends Resource
class_name OneChoiceData

enum Status {GAIN, LOSS}

@export var status : Status
@export var outcome_text : String
@export var health_change : int
@export var sanity_change : int
@export var advancement : int
@export var ammunition_change : int
@export var morale_change : int
