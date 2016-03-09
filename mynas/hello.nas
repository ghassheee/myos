; hello-os
; TAB=4
; Begin MasterBootRecord

        ORG     0x7c00          ; このプログラムがメモリのどこに読み込まれるのか

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述

        JMP     entry
        DB      0x90
        DB      "HELLOIPL"      ; ブートセクタの名前を自由に書いてよい（8バイト）
        DW      512             ; 1セクタの大きさ（512にしなければいけない）
        DB      1               ; クラスタの大きさ（1セクタにしなければいけない）
        DW      1               ; FATがどこから始まるか（普通は1セクタ目からにする）
        DB      2               ; FATの個数（2にしなければいけない）
        DW      224             ; ルートディレクトリ領域の大きさ（普通は224エントリにする）
        DW      2880            ; このドライブの大きさ（2880セクタにしなければいけない）
        DB      0xf0            ; メディアのタイプ（0xf0にしなければいけない）
        DW      9               ; FAT領域の長さ（9セクタにしなければいけない）
        DW      18              ; 1トラックにいくつのセクタがあるか（18にしなければいけない）
        DW      2               ; ヘッドの数（2にしなければいけない）
        DD      0               ; パーティションを使ってないのでここは必ず0
        DD      2880            ; このドライブ大きさをもう一度書く
        DB      0,0,0x29        ; よくわからないけどこの値にしておくといいらしい
        DD      0xffffffff      ; たぶんボリュームシリアル番号
        DB      "HELLO-OS   "   ; ディスクの名前（11バイト）
        DB      "FAT12   "      ; フォーマットの名前（8バイト）
        resb    18              ; とりあえず18バイトあけておく

; プログラム本体



entry:
        MOV     AX,0             ; b80000 レジスタ初期化
        MOV     SS,AX      ; 8ed0
        MOV     SP,0x7c00  ; bc007c
        MOV     DS,AX      ; 8ed8
        MOV     ES,AX      ; 8ec0

        MOV     SI,msg     ; be747c


putloop:
        MOV     AL,[SI]    ; 8a0483
        ADD     SI,1             ; c601 SIに1を足す
        CMP     AL,0       ; 3c00
        JE      fin        ; 7409
        MOV     AH,0x0e      ; b40e 一文字表示ファンクション
        MOV     BX,15            ; bb0f00 カラーコード
        INT     0x10             ; cd10 ビデオBIOS呼び出し
        JMP     putloop    ; ebee


fin:
        HLT                        ; f4 何かあるまでCPUを停止させる
        JMP     fin              ; ebfd 無限ループ

    0a0a 6865 6c6c 6f2c 2077 6f72 6c64 0a00
msg:
        DB      0x0a, 0x0a      ; 改行を2つ
        DB      "hello, world"
        DB      0x0a            ; 改行
        DB      0

        resb    0x7dfe-$        ; 0x7dfeまでを0x00で埋める命令

        DB      0x55, 0xaa

; End MasterBootRecord
; 以下はブートセクタ以外の部分の記述

        DB      0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
        resb    4600
        DB      0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00

        resb    1469432
