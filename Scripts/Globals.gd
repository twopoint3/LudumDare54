extends Node

signal score_changed
var player_health = 5
var score = 0 :
    set(value):
        score = value
        emit_signal("score_changed")