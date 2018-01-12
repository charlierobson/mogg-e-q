    .emptyfill  0
    .org        $4009

#include "include/sysvars.asm"
#include "include/zxline0.asm"

    .exportmode NO$GMB          ; xxxx:yyyy NAME
    .export

#include "yield.asm"
#include "ostore.asm"

.define ADD_HL_A add a,l \ ld l,a \ adc a,h \ sub l \ ld h,a

    .asciimap   'A','Z',{*}-'A'+$26
    .asciimap   '0','9',{*}-'0'+$1c
    .asciimap   ' ',' ',$00
    .asciimap   ':',':',$0e
    .asciimap   '-','-',$16
    .asciimap   ',',',',$1a
    .asciimap   '.','.',$1b

charset = $2000
charsetx:
    .incbin "zx81plus.bin"

OSTORE = $2400
FREELIST = OSTORE + (NSTRUCTS * OSTRUCTSIZE)

inputstates:
    .byte    %10000000,4,%00001000,0        ; up      (Q)
    .byte    %01000000,4,%00010000,0        ; down    (A)
    .byte    %00100000,3,%00010000,0        ; left    (N)
    .byte    %00010000,4,%00000100,0        ; right   (M)
    .byte    %00001000,4,%00000001,0        ; play    (SP)
    .byte    %11111111,0,%11111111,0        ;
    .byte    %11111111,0,%11111111,0        ;
    .byte    %11111111,0,%11111111,0        ;

; ------------------------------------------------------------
starthere:
    out     ($fd),a

    ld      bc,$e007            ; go low, ram at 8-40k
    ld      a,$b2
    out     (c),a

    call    initostore

    call    getobject
    ld      bc,fnmain
    call    initobject
    ld      hl,OSTORE
    ld      (OSTORE+ONEXT),hl
    ld      (OSTORE+OPREV),hl

    ld      hl,charsetx 
    ld      de,charset
    ld      bc,$400
    ldir

    ld      hl,charset+$200
    ld      bc,$00ff
-:  ld      a,(hl)
    xor     c
    ld      (hl),a
    inc     hl
    djnz    {-}

;    ld      a,$18
;    ld      (charset+3),a
;    ld      (charset+4),a

    ld      a,$21       ; go udg!
    ld      i,a

    call    openmidi

    ld      bc,selectaLR
    call    objectbeforehead

    ld      bc,selectaUD
    call    objectbeforehead
    ld      a,0
    ld      (de),a

    ld      bc,selectaUD
    call    objectbeforehead
    ld      a,1
    ld      (de),a

    ld      bc,selectaUD
    call    objectbeforehead
    ld      a,2
    ld      (de),a

    ld      bc,selectaUD
    call    objectbeforehead
    ld      a,3
    ld      (de),a

    call    printstring
    .byte   0,12
    ;        --------========--------========
    .asc    "CURSOR KEYS: ALTER SLIDERS"
    .byte   $40
    .asc    "          0: PLAY NOTE"
    .byte   $F0

    call    printstring
    .byte   9,23
    .asc    "MOGG-E-Q V0.00"
    .byte   $F0

	out     ($fe),a

    ; here's the main loop, the root

fnmain:
    call    readinput
    call    waitvsync
    YIELD

    ld      a,(play)
    cp      1
    call    z,playmiddlec

    jr      fnmain



    ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    ;
    ; Kill time until we notice the FRAMES variable change
    ;
    ; A display has just been produced, and now we can continue.
    ;
waitvsync:
    ld      hl,FRAMES
    ld      a,(hl)
-:  cp      (hl)
    jr      z,{-}
    ret

#include "util.asm"
#include "input.asm"
#include "midi.asm"
#include "selectaUD.asm"
#include "selectaLR.asm"

endhere:
; ------------------------------------------------------------

#include "include/zxline1.asm"

    .end
