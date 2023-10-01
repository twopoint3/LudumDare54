extends Area2D

@export_enum("Heal", "None", "Lazer", "GigaMode", "Bomb") var type: String
@export var score = 0
@export var heal_amount = 1
#@export_flags ("GIVESCORE", "POWERUP") var types: int = 0
