
;; Definitions
include "src/includes/hardware.inc"
include "src/defines/constants.asm"
include "src/defines/jumptable.asm"

;; RAM
section "random", WRAM0[$C000]
randstate:: ds 4

;; Home
include "src/home/jump_table.asm"
include "src/home/copy_dma.asm"
include "src/home/random.asm"
include "src/home/graphics.asm"

include "src/test/test.asm"

;; Entry point
section "Entry", ROM0[$0100]
EntryPoint:
  nop
  jp main

;; Make room for Header
section "Header", ROM0[$0104]
ds $0150 - @, 0

;; Main
main:
  call copy_dma

  call wait_vblank
  call lcd_toggle

  call copy_bg_tile_data
  call generate_map_simple

  ;call test_tile_map

  call lcd_toggle

.main_loop:
  jp .main_loop


;; Generate basic map
generate_map_simple::
  ld hl, map
  ld bc, (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)

.loop:
  push bc
  push hl
  call rand
  pop hl
  pop bc

  cp $7F
  jp nc, .lesser
  
.greater:
  ld a, $00
  ld [hl+], a
  jp .continue

.lesser:
  ld a, $01
  ld [hl+], a

.continue:
  dec bc
  ld a, b
  or a, c
  jp nz, .loop
 
  call set_map_tiles

  ret


;;
set_map_tiles::
  ld hl, _SCRN0
  ld de, map
  ld bc, (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)
  xor a
  ld [floor_round], a

.loop:
  ld a, [de]
  cp 1
  jp nz, .air

.wall:
  ld a, [cross_temp]
  ld [hl+], a
  ld a, [cross_temp+1]
  ld [hl+], a

  push hl
  xor a
  ld a, l
  add 30
  ld l, a
  ld a, h
  adc 0
  ld h, a

  ld a, [cross_temp+2]
  ld [hl+], a
  ld a, [cross_temp+3]
  ld [hl], a
  pop hl
  jp .check_tile
  
.air:
  ld a, 0
  ld [hl+], a
  ld a, 0
  ld [hl+], a

  push hl
  xor a
  ld a, l
  add 30
  ld l, a
  ld a, h
  adc 0
  ld h, a

  ld a, 0
  ld [hl+], a
  ld a, 0
  ld [hl], a
  pop hl

.check_tile:
  ld a, [floor_round]
  inc a
  cp MAP_SIZE_WIDTH
  ld [floor_round], a
  jp nz, .final

  xor a
  ld [floor_round], a
  ld a, l
  add 30 + ((MAP_SIZE_WIDTH / 16) * 2)
  ld l, a
  ld a, h
  adc 0
  ld h, a

.final
  inc de
  dec bc
  ld a, b
  or c
  jp nz, .loop




section "current_floor", WRAM0[$C010]
floor_number:: ds 2
floor_type:: ds 1
floor_round:: ds 1
map:: ds TILE_SIZE * (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)




section "rom2_table", ROMX[$4000], BANK[2]
db $02

dw $0000
dw $0000
dw $0000
dw $0000
dw $0000
dw $0000
dw $0000
dw $0000
dw $0000
dw $0000
dw $FFFF

