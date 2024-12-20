package main

//import "game_cards"
import "core:fmt"
import ecs "shared:ecs"
import rl "vendor:raylib"

CURSOR_SPEED :: 400
ALLY_SPAWN_POS :: rl.Vector2{100, 320}

ctx: ecs.Context

Player :: struct {
	hp:   int,
	hand: [dynamic]ecs.Entity,
	mana: int,
}

Board :: struct {
	allyUnits: [dynamic]ecs.Entity,
	enemyUnits: [dynamic]ecs.Entity,
}

draw_hand :: proc(player: ^Player) {
	infantry := ecs.create_entity(&ctx)
	ecs.add_component(&ctx, infantry, create_card(CardType.Infantry))
	tank := ecs.create_entity(&ctx)
	ecs.add_component(&ctx, tank, create_card(CardType.Tank))
	mech := ecs.create_entity(&ctx)
	ecs.add_component(&ctx, mech, create_card(CardType.Mech))

	//	append(&player.hand, infantry, tank, mech)
	append_elem(&player.hand, tank)
}

play_card :: proc(card_index: int, player: ^Player, board: ^Board) {
	card := player.hand[card_index]
	card_component, err := ecs.get_component(&ctx, card, GameCard)
	ecs.add_component(&ctx, card, create_unit(card_component^, ALLY_SPAWN_POS))
	ordered_remove(&player.hand, card_index)
	append(&board.allyUnits, card)
}

main :: proc() {
	ctx = ecs.init_ecs()
	defer ecs.deinit_ecs(&ctx)

	rl.InitWindow(1280, 720, "My First Game")

	playerEntity := ecs.create_entity(&ctx)
	playerComp, err := ecs.add_component(
		&ctx,
		playerEntity,
		Player{hp = 100, hand = {}, mana = 10},
	)

	board := Board {
		allyUnits = {},
	}

	draw_hand(playerComp)
	play_card(0, playerComp, &board)
	player_pos := rl.Vector2{120, 320}
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		move_cursor(&player_pos)

		unit := &board.allyUnits[0]
		fmt.print(unit^)
		fmt.print("printed unit")
		//render_cards(&board)
		fmt.print("hi")
		card, disp_err := ecs.get_component(&ctx, unit^, GameCard)
		fmt.print("hi")
		unitComp, unit_err := ecs.get_component(&ctx, unit^, Unit)

		rl.DrawRectangleV(unitComp.position, card.disp.size, card.disp.color)
		rl.DrawRectangleV(player_pos, {64, 64}, rl.GREEN)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}

render_cards :: proc(board: ^Board) {
	for unit in board.allyUnits {
		fmt.print("hi")
		unitComp, unit_err := ecs.get_component(&ctx, unit, Unit)
		fmt.print("hi")
		card, disp_err := ecs.get_component(&ctx, unit, GameCard)
		fmt.print("hi")
		rl.DrawRectangleV(unitComp.position, card.disp.size, card.disp.color)
	}
}

handle_movement :: proc() {cursor_pos: ^rl.Vector2, board: ^Board) {
	for unit in board.allyUnits {
	
	}
	
}
move_cursor :: proc(player_pos: ^rl.Vector2) {
	if rl.IsKeyDown(.UP) {
		player_pos.y -= CURSOR_SPEED * rl.GetFrameTime()
	}

	if rl.IsKeyDown(.DOWN) {
		player_pos.y += CURSOR_SPEED * rl.GetFrameTime()
	}
}
