extends TextureButton

var fullColor: Color = Color(1.0,1.0,1.0,1.0)
var halfColor: Color = Color(0.5,0.5,0.5,0.5)
#onready var symbols: AspectRatioContainer = $AspCont_Symbols

# change visibility of symbols on presses
#func _process(_delta):
	#print(self.button_mask)
#	if self.pressed and showAnimation():
#		symbols.modulate = fullColor
#	else:
#		symbols.modulate = halfColor

# Check is animation should be played at all
func showAnimation():
	return Settings.cues.COLOR in Settings.cue

# Sets the texture button to pressed
func simulatePress():
	# Show button press only if it's not blind mode,
	# but keep the delay and audio and other cues
	if showAnimation():
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
