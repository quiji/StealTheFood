
extends Node2D
var Smooth = preload("res://classes/Smoothstep.gd")



func _ready():
	
	$interpolator.set_method(self, "inter")
	$interpolator2.set_method(self, "inter2")
	$interpolator3.set_method(self, "inter3")
	$interpolator4.set_method(self, "inter4")
	$interpolator5.set_method(self, "inter5")



func inter(t):
	return Smoothstep.cross(t, Smoothstep.start3(t), Smoothstep.stop3(t))

func inter2(t):
	return Smoothstep.start2(Smoothstep.stop6(t))


func inter3(t):
	return Smoothstep.start2(t)

func inter4(t):
	return Smoothstep.cross(t, Smoothstep.arch(Smoothstep.start3(t + 0.5)), t)

func inter5(t):
	return Smoothstep.cross(t, Smoothstep.arch(Smoothstep.stop6(t), 2), Smoothstep.flip(Smoothstep.arch(Smoothstep.start6(t), 0.5)))


