extends Node

signal score_changed
var player_health = 5
var score = 0 :
    set(value):
        score = value
        emit_signal("score_changed")
var real_score = 0

func set_score_back_to_start():
    score = real_score