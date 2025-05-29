
;; Definitions
include "src/includes/hardware.inc"

;; RAM

;; Home

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
  jp main

