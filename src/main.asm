
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

  call generate_map_simple

  call copy_bg_tile_data

  call lcd_toggle

.main_loop:
  jp .main_loop


;; Generate basic map
generate_map_simple::
  ld hl, map
  ld bc, (MAP_SIZE_WIDTH * MAP_SIZE_HEIGHT)

.loop:
  ld a, $01
  ld [hl+], a
  ;ld a, $00
  ;ld [hl+], a
  ;ld [hl+], a
  ;ld [hl+], a
  dec bc
  ld a, b
  or a, c
  jp nz, .loop

  ret

section "current_floor", WRAM0[$C010]
floor_number:: ds 2
floor_type:: ds 1
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

