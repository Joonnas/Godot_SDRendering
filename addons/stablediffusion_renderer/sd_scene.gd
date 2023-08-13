@tool
extends Node3D
class_name SD_Scene3D

var subviewport : SubViewport
var sv_camera : Camera3D
var sv_mesh : MeshInstance3D
var sv_texture : TextureRect

const depth_shader = preload("res://addons/stablediffusion_renderer/shader/depth_map.gdshader")
const sobel_shader = preload("res://addons/stablediffusion_renderer/shader/sobelsedge.gdshader")
const camera_env = preload("res://addons/stablediffusion_renderer/other_res/Viewport_Environment.tres")

@export_group("Scene elements")
@export var camera : Camera3D

@export_group("Special Render settings")
@export var controlnet_option: SD_Renderer.CN_Options = SD_Renderer.CN_Options.DEPTH :
	get:
		return controlnet_option

@export var sd_prompt : String = "" :
	get:
		return sd_prompt
@export var sd_negative_prompt : String = "" :
	get:
		return sd_negative_prompt

func get_texture():
	return subviewport.get_texture().get_image()

func _ready():
	if not Engine.is_editor_hint():
		subviewport = SubViewport.new()
		sv_camera = Camera3D.new()
		sv_mesh = MeshInstance3D.new()
		sv_texture = TextureRect.new()
		
		sv_mesh.mesh = QuadMesh.new()
		sv_mesh.mesh.size = Vector2(2.0, 2.0)
		sv_mesh.mesh.material = ShaderMaterial.new()
		sv_mesh.mesh.material.shader = depth_shader if (controlnet_option == SD_Renderer.CN_Options.DEPTH) else sobel_shader
		sv_mesh.mesh.flip_faces = true
		for i in range(20):
			sv_mesh.set_layer_mask_value(i, false)
		sv_mesh.set_layer_mask_value(19, true)
		sv_mesh.set_layer_mask_value(20, true)
		print(depth_shader)
		
		sv_camera.add_child(sv_mesh)
		for i in range(20):
			sv_camera.set_cull_mask_value(i, false)
		sv_camera.set_cull_mask_value(19, true)
		sv_camera.set_cull_mask_value(20, true)
		sv_camera.environment = camera_env
		sv_camera.current = true
		sv_camera.position = camera.position
		sv_camera.rotation_degrees = camera.rotation_degrees
		
		subviewport.add_child(sv_camera)
		subviewport.size = Vector2i(384, 216)
		subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		subviewport.transparent_bg = true
		
		self.add_child(subviewport)
