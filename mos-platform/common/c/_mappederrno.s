; Copyright 2024 LLVM-MOS Project
; Licensed under the Apache License, Version 2.0 with LLVM Exceptions.
; See https://github.com/llvm-mos/llvm-mos-sdk/blob/main/LICENSE for license
; information.

; Originally from cc65. Modified from original version.

;
; 2003-08-12, Ullrich von Bassewitz
; 2015-09-24, Greg King
;
; Helper function for several high-level file functions.
;

        .include        "errno.inc"

; ----------------------------------------------------------------------------
; int __fastcall__ __mappederrno (unsigned char code);
; /* Set __oserror to the given platform-specific error code. If it is a real
; ** error code (not zero), set errno to the corresponding system error code,
; ** and return -1. Otherwise, return zero.
; ** Used by the library.
; */

.globl __mappederrno
__mappederrno:
        sta     __oserror               ; Store the error code
        tax                             ; Did we have an error?
        beq     ok                      ; Branch if no
        jsr     __osmaperrno            ; Map OS error into errno code
        jsr     __seterrno              ; Save in errno (returns with .A = 0)
        lda     #$FF                    ; Return -1 if error
        tax
ok:     rts
