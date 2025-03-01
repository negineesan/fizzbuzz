.code
extrn ExitProcess: proc
extrn GetStdHandle: proc
extrn WriteConsoleA: proc

.data
fizz_str BYTE "Fizz", 0
buzz_str BYTE "Buzz", 0
fizzbuzz_str BYTE "FizzBuzz", 0
newline BYTE 0Dh, 0Ah, 0
start_msg BYTE "Start_FizzBuzz...", 0Dh, 0Ah, 0
std_out_handle QWORD ?
bytes_written QWORD ?

.code
main proc
    push rbp
    mov rbp, rsp
    and rsp, -10h

    ; Get standard output handle
    mov rcx, -11
    call GetStdHandle
    mov std_out_handle, rax
    
    ; print start message
    sub rsp, 28h
    lea rdx, start_msg
    mov rcx, rax
    mov r8, sizeof start_msg - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h

    mov rsi, 1      ; rsiをループカウンタとして設定

loop_start:
    cmp rsi, 101
    jge loop_end

    mov rax, rsi
    mov rdx, 0
    mov rbx, 3
    div rbx
    cmp rdx, 0
    jne check_buzz
    
    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, fizz_str
    mov r8, sizeof fizz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    jmp print_newline

check_buzz:
    mov rax, rsi
    mov rdx, 0
    mov rbx, 5
    div rbx
    cmp rdx, 0
    jne check_fizzbuzz

    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, buzz_str
    mov r8, sizeof buzz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    jmp print_newline

check_fizzbuzz:
    mov rax, rsi
    mov rdx, 0
    mov rbx, 15
    div rbx
    cmp rdx, 0
    jne print_number

    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, fizzbuzz_str
    mov r8, sizeof fizzbuzz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    jmp print_number ; test

print_number:
    sub rsp, 32                 ; convert_to_string呼び出し前に領域確保（align維持）
    
    mov rax, rsi                ; rsiの数値をraxに移動
    call convert_to_string      ; 文字列(RAX)とその長さ(RCX)で返る

    ; rax文字列の先頭ポインタ、rcxに長さ
    mov rdx, rax                ; rdxに文字列アドレスをセット（WriteConsoleA用）
    mov r8, rcx                 ; r8に文字列長さをセット（WriteConsoleA用）
    mov rcx, std_out_handle     ; 標準出力のハンドル
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    
    add rsp, 32                 ; スタック復元

print_newline:
    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, newline
    mov r8, sizeof newline - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h

    inc rsi
    jmp loop_start

loop_end:
    mov rsp, rbp
    pop rbp
    mov rcx, 0
    call ExitProcess

; 入力：raxに整数（符号なし）
; 出力：raxに文字列先頭ポインタ、rcxに文字列長
convert_to_string proc
    sub rsp, 32                ; 文字列バッファを確保
    mov rdi, rsp               ; スタックトップを文字列の先頭に設定
    mov rcx, 0                 ; 長さ初期化

    mov rbx, 10
    test rax, rax              ; raxが0なら特別処理
    jnz convert_loop
    mov byte ptr [rdi], '0'
    mov rcx, 1
    jmp convert_done

convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz convert_loop

    mov rsi, rcx
    mov rdx, rdi

copy_loop:
    pop rax
    mov [rdx], al
    inc rdx
    dec rsi
    jnz copy_loop

convert_done:
    mov rax, rdi ; raxに文字列の先頭アドレスをセットして返す
    ; rcxに文字列の長さをセットして返す
    ret
convert_to_string endp

main endp
end
