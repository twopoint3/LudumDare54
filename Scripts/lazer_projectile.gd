extends BasicProjectile

@onready var animation_player = $AnimationPlayer

func shake_camera():
    Utilities.shake_camera(2)