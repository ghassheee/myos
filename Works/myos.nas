;
CYLN    EQU    10
ORG     0x7c00

JMP     entry

DB      0x90
DB      "HELLOIPL"      ;  8 bytes

DW      512
DB      1
DW      1       ; start point of FAT file system
DB      2       ; number of FAT
DW      224     ; size of root directory [entry]
DW      2880    ; size of this drive [sector]
DB      0xf0    ; type of media
DW      9       ; the length of FAT region is 9
DW      18      ; how many sectors in one truck ? 18 .
DW      2       ; number of head is 2
DD      0       ; number of partition
DD      2880
DB      0,0,0x29
DD      0xffffffff      ; serial number of volume
DB      "HELLO-OS   "   ; 11 bytes
DB      "FAT12   "      ;  8 bytes
RESB    18

entry:
    MOV     AX,0
    MOV     SS,AX
    MOV     SP,0x7c00
    MOV     DS,AX
    ; LOAD DISK
    MOV     AX,0x0820
    MOV     ES,AX
    MOV     CH,0        ; Cylinder = 0
    MOV     CL,2        ; Head = 2
    MOV     DH,0        ; Sector = 0

readloop:
    MOV     SI,0        ;counter
retry:
    MOV     AH,0x08     ; Read Mode 0x08 : GET DRIVE PARAMETERS
    MOV     AL,1        ; length of sector = 1
    MOV     BX,0        ; [ES:BX] = [0x8200]
    MOV     DL,0x80     ; select HARD-DISK-Drive
    INT     0x13        ; LOAD DISK (READ) IF error THEN "CarryFlag" == 1
    JNC     next        ; JNC : "jump if not Carry"
    ADD     SI,1        ; counter++
    CMP     SI,5        ;
    JAE     error       ; JAE : "jump if above or equal"
                        ; if SI >= 5 then goto error
    MOV     AH,0x00     ; Reset Mode
    MOV     DL,0x80     ; select HARD-DISK-Drive
    INT     0x13        ; LOAD DISK (RESET)
    JMP     retry
next:
    MOV     AX,ES       ;
    ADD     AX,0x0020   ;
    MOV     ES,AX       ; proceed address by 0x200 bytes
    ADD     CL,1        ; sector++
    CMP     CL,18
    JBE     readloop    ; JBE : "jmp if below or equal"
    MOV     CL,1
    ADD     DH,1        ; head++
    CMP     DH,2
    JBE     readloop    ;
    MOV     DH,0
    ADD     CH,1        ; cylinder++
    CMP     CH,CYLN
    JBE     readloop

; move to OS
    MOV [0x0ff0],CH     ; remember the cylinder
    JMP 0xc200




error:
    MOV     SI,msg
putloop:
    MOV     AL,[SI]
    ADD     SI,1
    CMP     AL,0        ;if (AL == 0) then JE fin else MOV AH,0x0e
    JE      fin
    MOV     AH,0x0e
    MOV     BX,15       ;color
    INT     0x10        ;print one character if AH == 0x0e
                        ;AL == ASCII character to write
                        ;BH == page number (text mode )
                        ;BL == foreground pixel color graphic mode
    JMP     putloop     ;JMP := "jump to" = "goto"
fin:
    HLT
    JMP     fin
msg:
    DB      0x0a,0x0a           ;'\n\n'
    DB      0x07                ;BEEP
    DB      "LOAD ERROR!"
    DB      0x0a
    DB      0
    RESB    0x1fe-($-$$)
    DB 0x55,0xaa
