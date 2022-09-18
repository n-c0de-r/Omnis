extends TextureButton

onready var timer: Timer = $Timer

# Sets the texture button to pressed
func simulatePress():
	self.set_toggle_mode(true)
	self.set_pressed_no_signal(true)
	return self

# Sets the texture button to released
func simulateRelease():
	self.set_pressed_no_signal(false)
	self.set_toggle_mode(false)
	return self

# Starts the attached timer with given time
func startTimer(time):
	timer.start(time)

func _on_Timer_timeout():
	simulateRelease()
