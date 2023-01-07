extends CanvasLayer

func _ready():
	$ColorRect.visible	 = false
	$Label.visible		 = false
	get_tree().paused	 = false

func _process(delta):
	if Input.is_action_just_pressed("ui_backspace"):
		if not get_tree().paused:
			$ColorRect.visible	 = true
			$Label.visible		 = true
			get_tree().paused	 = true
		else:
			$ColorRect.visible	 = false
			$Label.visible		 = false
			get_tree().paused	 = false
