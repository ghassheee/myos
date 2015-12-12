;
ORG     0x7c00


JMP     entry
DB      0x90
DB      "HELLOIPL"      ;  8 bytes
DW      512
DB      1
DW      1       ; where to start FAT
DB      2       ; number of FAT
DW      224     ; size of root directory 
DW      2880    ; size of this drive
DB      0xf0
DW      9
DW      18
DW      2
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
    MOV     CH,0        ;Cylinder = 0
    MOV     DH,0        ;Sector = 0
    MOV     CL,2        ;Head = 2

    MOV     AH,0x02     ;READ mode
    MOV     AL,1        ;length of sector = 1
    MOV     BX,0        ;[ES:BS] = [0x8200]
    MOV     DL,0x00     ;A drive
    INT     0x13        ;LOAD DISK OPERATION!!
    JC      error


    MOV     ES,AX

    MOV     SI,msg

putloop:
    MOV     AL,[SI]
    ADD     SI,1
    CMP     AL,0
    JE      fin
    MOV     AH,0x0e
    MOV     BX,15
    INT     0x10
    JMP     putloop

fin: 
    HLT
    JMP     fin

msg: 
    DB      0x0a,0x0a
    DB      "HELLO,WORLD!"
    DB      0x0a
    DB      0

    RESB    0x1fe-($-$$)

    DB 0x55,0xaa




error:


