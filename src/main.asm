
;; Definitions
include "src/includes/hardware.inc"
include "src/defines/constants.asm"
include "src/defines/jumptable.asm"

;; RAM
include "src/wram/floor.asm"
include "src/wram/misc.asm"

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


;; Functions
include "src/map.asm"


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

