extends TextureButton

var fullColor: Color = Color(1.0,1.0,1.0,1.0)
var halfColor: Color = Color(0.5,0.5,0.5,0.5)

func _ready():
	_updateParts(self.rect_rotation)

# change visibility of symbols on presses
func _process(_delta):
	if "Color" in Utils.cues and self.pressed:
		$Symbol.self_modulate = fullColor
	else:
		$Symbol.self_modulate = halfColor

# Update all symbols and texts in relation to buttons rotation
func _updateParts(degree: int):
	var sine: float = 0 - 0.25 * abs(sin(deg2rad(-degree)))
	$Symbol.rect_rotation -= degree
	$Text.rect_rotation -= degree
	$Text.anchor_top = sine
	$Text.anchor_bottom = sine
	
# Plays button press animation
func animate(time: int):
	$Animation.play("press_%ss" % time)

# Plays a tweened custom animation of rotating the button
func rotateButton(degree: int, time: float):
	time = time * Utils.timerFactor
	# Generate Tweeners
	var tweens: Array
	for i in 5:
		tweens.append(get_tree().create_tween())
		
	# Animate the rotation
	var sine: float = 0 - 0.25 * abs(sin(deg2rad($Text.rect_rotation - degree)))
	tweens[0].tween_property(self, "rect_rotation", self.rect_rotation + degree, time)
	tweens[1].tween_property($Symbol, "rect_rotation", $Symbol.rect_rotation - degree, time)
	tweens[2].tween_property($Text, "rect_rotation", $Text.rect_rotation - degree, time)
	tweens[3].tween_property($Text, "anchor_top", sine, time)
	tweens[4].tween_property($Text, "anchor_bottom", sine, time)

# Sets chosen theme of symbols
func setSymbol():
	pass

# Sets description texts for buttons
func setText():
	pass

# Sets the texture button to pressed
func simulatePress():
	# Show button press only if it's not blind mode,
#	# but keep the delay and audio and other cues
	if "Color" in Utils.cues:
		self.set_toggle_mode(true)
		self.set_pressed_no_signal(true)
	return self

# Sets the texture button to released
func simulateRelease():
	self.set_pressed_no_signal(false)
	self.set_toggle_mode(false)
