extends Node2D

func _ready():
	self.visible = false
	$anim.play("padrao")

func _physics_process(delta):
	self.global_rotation += .03
