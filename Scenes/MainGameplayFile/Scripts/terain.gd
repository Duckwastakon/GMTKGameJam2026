extends MeshInstance3D

const size = 256

var offset: float = 0
var newRayCast3D: RayCast3D

@export var speed: int
@export var noise: FastNoiseLite

@export_range(4, 256, 4) var resolution = 32

@export_range(4.0, 128.0, 4.0) var height = 64.0

func getHeight(x:float, y:float) -> float:
	return noise.get_noise_2d(x, y) * height

func getNormal(x:float, y:float) -> Vector3:
	var epsilon = size / resolution
	var normal = Vector3((getHeight(x+epsilon, y) - 
	getHeight(x-epsilon, y))/(2.0*epsilon), 1.0, (getHeight(x, y+epsilon) - 
	getHeight(x, y-epsilon))/(2.0*epsilon))
	
	return normal.normalized()

func updateMesh():
	var plane = PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	
	plane.size = Vector2(size, size)
	noise.offset = Vector3(offset, 0, 0)
	
	var planeArray = plane.get_mesh_arrays()
	var vertexArray: PackedVector3Array = planeArray[ArrayMesh.ARRAY_VERTEX]
	var normalArray: PackedVector3Array = planeArray[ArrayMesh.ARRAY_NORMAL]
	var tangentArray: PackedFloat32Array = planeArray[ArrayMesh.ARRAY_TANGENT]
	
	for i:int in vertexArray.size():
		var vertex = vertexArray[i]
		var normal = Vector3.UP
		var tang = Vector3.RIGHT
		
		if noise:
			vertex.y = getHeight(vertex.x, vertex.z)
			normal = getNormal(vertex.x, vertex.z)
			tang = normal.cross(Vector3.UP)
		vertexArray[i] = vertex
		normalArray[i] = normal
		tangentArray[4 * i + 1] = tang.y
		tangentArray[4 * i + 2] = tang.z
	
	var arrMesh = ArrayMesh.new()
	arrMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, planeArray)
	mesh = arrMesh
	#get_parent().get_child(1).shape = arrMesh.create_trimesh_shape()
	
	#if newRayCast3D.is_colliding():
		#print(newRayCast3D.get_collision_point().y)
		#global_position.y = newRayCast3D.get_collision_point().y
	#else:
		#print("down")
		#global_position = Vector3(0, 0.1, 0)

func _ready() -> void:
	#newRayCast3D = RayCast3D.new()
	#get_parent().get_parent().add_child.call_deferred(newRayCast3D)
	#newRayCast3D.position = Vector3(0, 1, 0)
	#newRayCast3D.target_position = Vector3(0, -2, 0)
	while true:
		updateMesh()
		await get_tree().create_timer(0.01).timeout
		offset -= 1.0 * speed
