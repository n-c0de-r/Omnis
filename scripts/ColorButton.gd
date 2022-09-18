extends TextureButton

var fullColor: Color = Color(1.0,1.0,1.0,1.0)
var halfColor: Color = Color(0.5,0.5,0.5,0.5)

func _process(_delta):
	if self.pressed:
		$AspCont_Symbols.modulate = fullColor
	else:
		$AspCont_Symbols.modulate = halfColor

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
	$Timer.start(time)

func _on_Timer_timeout():
	simulateRelease()
