extends Node3D

const CHESS_FIELD_TILE = preload("res://games/chess/chess_field_tile.tscn")

const CHESS_FIELD_KING = preload("res://games/chess/pieces/King.tscn")
const CHESS_FIELD_QUEEN = preload("res://games/chess/pieces/Queen.tscn")
const CHESS_FIELD_ROOK = preload("res://games/chess/pieces/Rook.tscn")
const CHESS_FIELD_BISHOP = preload("res://games/chess/pieces/Bishop.tscn")
const CHESS_FIELD_KNIGHT = preload("res://games/chess/pieces/Knight.tscn")
const CHESS_FIELD_PAWN = preload("res://games/chess/pieces/Pawn.tscn")

var tiles = []

signal move_done

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_field()
	instantiate_field()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_field():
	
	for x in range(8):
		for y in range(8):
			var tile_instance = CHESS_FIELD_TILE.instantiate()
			tile_instance.position.x = y - 3.5
			tile_instance.position.z = x - 3.5
			tile_instance.tile_id.x = x
			tile_instance.tile_id.y = y
			tile_instance.click.connect(change_piece)
			tiles.append(tile_instance)
			self.add_child(tile_instance)

func instantiate_field():
	
	for i in range(2):
		# white = 0, black = 1
		var color = i
		var piecesNode = $Pieces
		
		var king = CHESS_FIELD_KING.instantiate()
		var queen = CHESS_FIELD_QUEEN.instantiate()
		var rook1 = CHESS_FIELD_ROOK.instantiate()
		var rook2 = CHESS_FIELD_ROOK.instantiate()
		var bishop1 = CHESS_FIELD_BISHOP.instantiate()
		var bishop2 = CHESS_FIELD_BISHOP.instantiate()
		var knight1 = CHESS_FIELD_KNIGHT.instantiate()
		var knight2 = CHESS_FIELD_KNIGHT.instantiate()
		
		rook1.position = Vector3(-3.5, rook1.position.y, -3.5 if color == 0 else 3.5)
		tiles[0 if color == 0 else 56].occupied = i
		
		knight1.position = Vector3(-2.5, knight1.position.y, -3.5 if color == 0 else 3.5)
		if i == 1:
			knight1.rotation = Vector3(0.0, PI, 0.0)
		tiles[1 if color == 0 else 57].occupied = i
		
		bishop1.position = Vector3(-1.5, bishop1.position.y, -3.5 if color == 0 else 3.5)
		tiles[2 if color == 0 else 58].occupied = i
		
		queen.position = Vector3(-0.5, queen.position.y, -3.5 if color == 0 else 3.5)
		tiles[3 if color == 0 else 59].occupied = i
		
		king.position = Vector3(0.5, king.position.y, -3.5 if color == 0 else 3.5)
		tiles[4 if color == 0 else 60].occupied = i
		
		bishop2.position = Vector3(1.5, bishop2.position.y, -3.5 if color == 0 else 3.5)
		tiles[5 if color == 0 else 61].occupied = i
		
		knight2.position = Vector3(2.5, knight2.position.y, -3.5 if color == 0 else 3.5)
		if i == 1:
			knight2.rotation = Vector3(0.0, PI, 0.0)
		tiles[6 if color == 0 else 62].occupied = i
		
		rook2.position = Vector3(3.5, rook2.position.y, -3.5 if color == 0 else 3.5)
		tiles[0 if color == 7 else 63].occupied = i
		
		rook1.player = i
		knight1.player = i
		bishop1.player = i
		queen.player = i
		king.player = i
		bishop2.player = i
		knight2.player = i
		rook2.player = i
		
		rook1.is_clicked.connect(piece_clicked)
		knight1.is_clicked.connect(piece_clicked)
		bishop1.is_clicked.connect(piece_clicked)
		queen.is_clicked.connect(piece_clicked)
		king.is_clicked.connect(piece_clicked)
		bishop2.is_clicked.connect(piece_clicked)
		knight2.is_clicked.connect(piece_clicked)
		rook2.is_clicked.connect(piece_clicked)
		
		piecesNode.add_child(rook1)
		piecesNode.add_child(knight1)
		piecesNode.add_child(bishop1)
		piecesNode.add_child(queen)
		piecesNode.add_child(king)
		piecesNode.add_child(bishop2)
		piecesNode.add_child(knight2)
		piecesNode.add_child(rook2)
		
		# pawns
		for e in range(8):
			var pawn = CHESS_FIELD_PAWN.instantiate()
			pawn.position = Vector3(e - 3.5, pawn.position.y, (5.0 * color) - 2.5)
			pawn.player = i
			pawn.is_clicked.connect(piece_clicked)
			piecesNode.add_child(pawn)
			
			tiles[(color * 48) + (abs(i - 1) * 8) + e].occupied = i

func make_move(player):
	for piece in $Pieces.get_children():
		piece.current_player = player
	for tile in tiles:
		tile.current_player = player

func change_piece(tile_id):
	var p = null
	for piece in $Pieces.get_children():
		if piece.active:
			p = piece
			break
	
	if p == null:
		return
	
	tiles[int(((p.position.z + 3.5) * 8) + (p.position.x + 3.5))].occupied = -1
	
	p.position.x = tile_id.y - 3.5
	p.position.z = tile_id.x - 3.5
	
	if tiles[(tile_id.x * 8) + tile_id.y].occupied != -1:
		var occupied_piece = null
		for piece in $Pieces.get_children():
			if piece.position.x == (tile_id.y - 3.5) and piece.position.z == (tile_id.x - 3.5) and piece.player != p.player:
				occupied_piece = piece
				break
		
		occupied_piece.in_game = false
		occupied_piece.position.y = -5.0
	
	tiles[(tile_id.x * 8) + tile_id.y].occupied = p.player
	p.active = false
	
	for tile in tiles:
		tile.can_state_change = false
	
	emit_signal("move_done")

func piece_clicked():
	for piece in $Pieces.get_children():
		piece.active = false
	for tile in tiles:
		tile.can_state_change = true
