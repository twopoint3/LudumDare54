extends Node2D

@export var time_extended = 2
@export var intervals:float = 2.0

@onready var timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = intervals
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	animation_player.play("Start")
	await get_tree().create_timer(time_extended).timeout
	animation_player.play_backwards("Start")
	timer.start()
