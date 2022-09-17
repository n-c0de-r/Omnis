extends TextureButton

onready var start: Timer = $Timer

func simulatePress():
	self.set_toggle_mode(true)
	self.set_pressed_no_signal(true)
	start.start(1)

func simulateRelease():
	self.set_pressed_no_signal(false)
	self.set_toggle_mode(false)

func _on_Timer_timeout():
	simulateRelease()
