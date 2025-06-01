
section "copy_dma", ROM0[$0080]
;; Copy DMA transfer function
; Destroys - a, b, c, hl
; Size     - 10b
copy_dma::
  ld c, _HRAMSTART
  ld b, 10
  ld hl, dma_data

.loop:
  ld a, [hl+]
  ldh [c], a
  inc c
  dec b
  jr nz, .loop

  ret


;; DMA function
; Destroys - a
; Size     - 10b
dma_data::
  ld a, $C0
  ldh [rDMA], a
  ld a, 40

.loop:
  dec a
  jr nz, .loop

  ret

