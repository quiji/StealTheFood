extends Container

enum OptionMenu {CONTINUE, EXIT}

const SELECTED_COLOR = Color("c98540")
const OPTION_COLOR = Color("c7cbc3")

var selected = CONTINUE
var menu_on = false

func _ready():
	$anim.connect("animation_finished", self, "anim_ended")

func update_options():
	if selected == CONTINUE:
		$anim.play("ExitUnselected")
	else:
		$anim.play("ContinueUnselected")

func show_menu():
	$anim.play("ShowMenu")
	menu_on = true
	$menu_sound.play()
	
func hide_menu():
	$anim.play("HideMenu")
	menu_on = false
	get_parent().pause_menu_hidden()

func anim_ended(anim_name):
	match anim_name:
		"ShowMenu":
			update_options()
		"HideMenu":
			pass
		"ContinueUnselected":
			$anim.play("ExitSelected")
		"ExitUnselected":
			$anim.play("ContinueSelected")
		"FlashContinue":
			hide_menu()
		"FlashExit":
			get_tree().quit()

func _input(event):
	
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		if selected == CONTINUE:
			selected = EXIT
		else:
			selected = CONTINUE
		$choose_sound.play()
		update_options()
		
	if Input.is_action_just_pressed("ui_accept") and menu_on:
		if selected == CONTINUE:
			$anim.play("FlashContinue")
		else:
			$anim.play("FlashExit")
		$select_sound.play()

