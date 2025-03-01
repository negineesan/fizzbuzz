; extern: 外部プロシージャ（このファイル内で定義されていない関数）を宣言します。
; これにより、リンカがこれらの関数を他のオブジェクトファイルやライブラリから見つけて結合できるようになります。
; ExitProcess: プログラムを正常終了させるためのWindows API関数です。
extrn ExitProcess: proc
; printf: Cランタイムライブラリに含まれる標準出力関数です。
; 書式指定文字列に従って、様々な型のデータを整形して出力します。
extrn printf: proc

; .dataセクション: ここからデータセグメントが始まることを宣言します。
; 初期化されたデータ（変数など）はここに配置されます。
.data

; format_str: printf関数で使用する書式指定文字列を定義します。
; "%d" は10進数整数を表し、0Dhと0Ahはそれぞれキャリッジリターン(CR)とラインフィード(LF)を表すASCIIコードで、改行を意味します。
; BYTE は、各要素が1バイトであることを示します。
format_str BYTE "%d", 0Dh, 0Ah, 0

; fizz_str: "Fizz"という文字列と改行コード(CRLF)を定義します。
; FizzBuzzプログラムで、3の倍数の時に出力する文字列です。
fizz_str BYTE "Fizz", 0Dh, 0Ah, 0

; buzz_str: "Buzz"という文字列と改行コード(CRLF)を定義します。
; FizzBuzzプログラムで、5の倍数の時に出力する文字列です。
buzz_str BYTE "Buzz", 0Dh, 0Ah, 0

; fizzbuzz_str: "FizzBuzz"という文字列と改行コード(CRLF)を定義します。
; FizzBuzzプログラムで、15の倍数の時に出力する文字列です。
fizzbuzz_str BYTE "FizzBuzz", 0Dh, 0Ah, 0

; .codeセクション: ここからコードセグメントが始まることを宣言します。
; アセンブラに対して、ここから機械語に翻訳すべき命令が記述されていることを伝えます。
.code
; main proc: メインプロシージャ（プログラムのエントリポイント）の開始を宣言します。
main proc
    ; push rbp: 現在のベースポインタレジスタ(rbp)の値をスタックにプッシュ（退避）します。
    ; rbpは、関数内でローカル変数や引数にアクセスするための基準点として使われます。
    push rbp

    ; mov rbp, rsp: 現在のスタックポインタレジスタ(rsp)の値をベースポインタレジスタ(rbp)にコピーします。
    ; これにより、現在のスタックの先頭を基準とした相対的なアドレス指定が可能になります。
    mov rbp, rsp

    ; sub rsp, 32: スタックポインタレジスタ(rsp)から32を引いて、スタック上に32バイトの領域を確保します。
    ; これは、この関数内で使用するローカル変数や、呼び出す関数の引数などを格納するためのスペース（シャドウイングスペース）です。
    sub rsp, 32

    ; mov rsi, 1: ループカウンタとして使用するrsiレジスタに1をセットします。
    ; これがFizzBuzzの処理を開始する最初の数値になります。
    mov rsi, 1

; loop_start: ループの開始地点を示すラベルです。
loop_start:
    ; cmp rsi, 101: ループカウンタ(rsi)の値と101を比較します。
    cmp rsi, 101

    ; jge loop_end: 比較の結果、rsiが101以上(ge: greater than or equal to)であれば、loop_endラベルにジャンプします。
    ; これがループの終了条件です。
    jge loop_end

    ; 15で割り切れるかチェック
    ; mov rax, rsi: ループカウンタ(rsi)の値を汎用レジスタraxにコピーします。
    ; raxは、除算命令(div)で被除数として使用されます。
    mov rax, rsi
    ; xor rdx, rdx: rdxレジスタを0でクリアします。
    ; 64ビット除算では、被除数はrdx:raxのペアで表されるため、rdxを0にしておく必要があります。
    xor rdx, rdx
    ; mov rbx, 15: 除数となる15をrbxレジスタにセットします。
    mov rbx, 15
    ; div rbx: raxレジスタの値をrbxレジスタの値で割ります。
    ; 商はraxに、余りはrdxに格納されます。
    div rbx
    ; cmp rdx, 0: 余りが格納されているrdxレジスタの値と0を比較します。
    cmp rdx, 0
    ; je print_fizzbuzz: もし余りが0であれば（つまり、rsiが15で割り切れれば）、print_fizzbuzzラベルにジャンプします。
    je print_fizzbuzz

    ; 3で割り切れるかチェック
    ; mov rax, rsi: ループカウンタ(rsi)の値をraxにコピーします。
    mov rax, rsi
    ; xor rdx, rdx: rdxレジスタを0クリアします。
    xor rdx, rdx
    ; mov rbx, 3: 除数となる3をrbxレジスタにセットします。
    mov rbx, 3
    ; div rbx: raxレジスタの値をrbxレジスタの値で割ります。商はrax、余りはrdxに格納されます。
    div rbx
    ; cmp rdx, 0: 余りが格納されているrdxレジスタの値と0を比較します。
    cmp rdx, 0
    ; je print_fizz: もし余りが0であれば（つまり、rsiが3で割り切れれば）、print_fizzラベルにジャンプします。
    je print_fizz

    ; 5で割り切れるかチェック
    ; mov rax, rsi: ループカウンタ(rsi)の値をraxにコピーします。
    mov rax, rsi
    ; xor rdx, rdx: rdxレジスタを0クリアします。
    xor rdx, rdx
    ; mov rbx, 5: 除数となる5をrbxレジスタにセットします。
    mov rbx, 5
    ; div rbx: raxレジスタの値をrbxレジスタの値で割ります。商はrax、余りはrdxに格納されます。
    div rbx
    ; cmp rdx, 0: 余りが格納されているrdxレジスタの値と0を比較します。
    cmp rdx, 0
    ; je print_buzz: もし余りが0であれば（つまり、rsiが5で割り切れれば）、print_buzzラベルにジャンプします。
    je print_buzz

    ; 数値をprintfで出力
    ; mov rcx, offset format_str: 書式指定文字列"%d\r\n"のアドレスをrcxレジスタにセットします。
    ; これはprintf関数の第1引数になります。
    mov rcx, offset format_str
    ; mov rdx, rsi: ループカウンタ(rsi)の値をrdxレジスタにセットします。
    ; これはprintf関数の第2引数（出力する数値）になります。
    mov rdx, rsi
    ; call printf: printf関数を呼び出します。
    call printf

    ; jmp loop_continue: 無条件ジャンプでloop_continueラベルに飛びます。
    jmp loop_continue

; print_fizzbuzz: 15で割り切れる場合の処理を行うラベルです。
print_fizzbuzz:
    ; mov rcx, offset fizzbuzz_str: "FizzBuzz\r\n"文字列のアドレスをrcxレジスタにセットします（printfの第1引数）。
    mov rcx, offset fizzbuzz_str
    ; call printf: printf関数を呼び出し、"FizzBuzz\r\n"を出力します。
    call printf
    ; jmp loop_continue: loop_continueラベルにジャンプします。
    jmp loop_continue

; print_fizz: 3で割り切れる場合の処理を行うラベルです。
print_fizz:
    ; mov rcx, offset fizz_str: "Fizz\r\n"文字列のアドレスをrcxレジスタにセットします（printfの第1引数）。
    mov rcx, offset fizz_str
    ; call printf: printf関数を呼び出し、"Fizz\r\n"を出力します。
    call printf
    ; jmp loop_continue: loop_continueラベルにジャンプします。
    jmp loop_continue

; print_buzz: 5で割り切れる場合の処理を行うラベルです。
print_buzz:
    ; mov rcx, offset buzz_str: "Buzz\r\n"文字列のアドレスをrcxレジスタにセットします（printfの第1引数）。
    mov rcx, offset buzz_str
    ; call printf: printf関数を呼び出し、"Buzz\r\n"を出力します。
    call printf
    ; jmp loop_continue: loop_continueラベルにジャンプします。
    jmp loop_continue

; loop_continue: ループの次のイテレーション（繰り返し）に進むためのラベルです。
loop_continue:
    ; inc rsi: ループカウンタ(rsi)の値を1増やします。
    inc rsi
    ; jmp loop_start: 無条件ジャンプでloop_startラベルに戻り、ループを継続します。
    jmp loop_start

; loop_end: ループの終了地点を示すラベルです。
loop_end:
    ; mov rsp, rbp: スタックポインタ(rsp)をベースポインタ(rbp)の値に戻します。
    ; これにより、関数呼び出し前のスタックの状態を復元します。
    mov rsp, rbp
    ; pop rbp: スタックに退避していたベースポインタ(rbp)の値を復元します。
    pop rbp
    ; mov rcx, 0: ExitProcess関数の第1引数（終了コード）を0に設定します。
    ; 0は正常終了を意味します。
    mov rcx, 0
    ; call ExitProcess: ExitProcess関数を呼び出して、プログラムを終了します。
    call ExitProcess

; main endp: メインプロシージャの終了を宣言します。
main endp
; end: アセンブリプログラム全体の終了を示します。
end
