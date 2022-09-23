extends Control

var buttons: Array
var speech: bool = Settings.speech
var subtitle: bool = Settings.subtitle

# Called when the node enters the scene tree for the first time.
func _ready():
	var buttons: Array = $ButtonRing.get_children()
	# Connect signals & set buttons to toggle mode
	for btn in buttons:
		var name = str(btn.name.to_lower().split("_")[1])
		btn.connect("button_up", self, "_on_" + name + "_button_up")
		btn.set_toggle_mode(true)
	
	# Setup the symbols
	for i in range(0,4):
		var asp: AspectRatioContainer = buttons[i].get_child(0)
		if i == 0:
			asp.get_node("./TxtRct_SubsOFF").visible = true
		if i == 1:
			asp.get_node("./TxtRct_SpeechON").visible = true
		if i == 2:
			asp.get_node("./TxtRct_SubsON").visible = true
		if i == 3:
			asp.get_node("./TxtRct_SpeechOFF").visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	checkInput()


# Update buttons according to settings
func update():
	speech = Settings.speech
	subtitle = Settings.subtitle
	
	$ButtonRing.blue.set_pressed_no_signal(!subtitle)
	$ButtonRing.red.set_pressed_no_signal(speech)
	$ButtonRing.yellow.set_pressed_no_signal(subtitle)
	$ButtonRing.green.set_pressed_no_signal(!speech)


# Checks user Input
func checkInput():
	# Sets global settings
	if Input.is_action_just_pressed("ui_up") && subtitle:
		Settings.subtitle = false
	elif Input.is_action_just_pressed("ui_down") && !subtitle:
		Settings.subtitle = true
	elif Input.is_action_just_pressed("ui_right") && !speech:
		Settings.speech = true
	elif Input.is_action_just_pressed("ui_left") && speech:
		Settings.speech = false
	# Update screen
	update()


# Signal callbacks for mouse input, it's a mess...
func _on_blue_button_up():
	Input.action_press("ui_up")
func _on_red_button_up():
	Input.action_press("ui_right")
func _on_yellow_button_up():
	Input.action_press("ui_down")
func _on_green_button_up():
	Input.action_press("ui_left")
