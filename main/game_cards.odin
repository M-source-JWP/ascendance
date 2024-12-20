// game_cards.odin

package main

import "core:fmt"
import ecs "shared:ecs"
import rl "vendor:raylib"

DisplayInfo :: struct {
	color: rl.Color,
	size:  rl.Vector2,
}

Unit :: struct {
	position:   rl.Vector2,
	velocity:   rl.Vector2,
	currHp:     int,
	currSpeed:  int,
	currAttack: int,
	range:      int,
}

create_unit :: proc(card: GameCard, pos: rl.Vector2) -> Unit {
	return Unit {
		position = pos,
		velocity = rl.Vector2{0, 0},
		currHp = card.hp,
		currSpeed = card.speed,
		currAttack = card.attack,
		range = card.range,
	}
}

GameCard :: struct {
	disp:    DisplayInfo,
	cost:    int,
	hp:      int,
	speed:   int,
	attack:  int,
	range:   int,
	n_units: int,
	name:    string,
	desc:    string,
}

// Enum to represent different card types
CardType :: enum {
	Infantry,
	Tank,
	Mech,
}

// Function to create a GameCard based on the card type
create_card :: proc(card_type: CardType) -> GameCard {
	switch card_type {
	case CardType.Infantry:
		{
			return GameCard {
				disp = DisplayInfo{color = rl.RED, size = {64, 32}},
				cost = 2,
				hp = 100,
				speed = 22,
				attack = 15,
				range = 2,
				name = "Infantry",
				desc = "A basic unit with moderate speed and attack.",
			}
		}
	case CardType.Tank:
		{
			return GameCard {
				disp = DisplayInfo{color = rl.GREEN, size = {128, 256}},
				cost = 6,
				hp = 300,
				speed = 1,
				attack = 30,
				range = 3,
				name = "Tank",
				desc = "A heavy unit with high defense and powerful attack.",
			}
		}
	case CardType.Mech:
		{
			return GameCard {
				disp = DisplayInfo{color = rl.BLACK, size = {128, 80}},
				cost = 4,
				hp = 175,
				speed = 3,
				attack = 40,
				range = 1,
				name = "Mech",
				desc = "A versatile unit with high melee damage output and moderate speed.",
			}
		}
		default: {
			panic("Invalid card type")
		}
	}
	panic("Invalid card type")
}
