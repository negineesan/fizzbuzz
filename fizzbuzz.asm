.code
extrn ExitProcess: proc
extrn printf: proc

.data
format_str BYTE "%d", 0Dh, 0Ah, 0
fizz_str BYTE "Fizz", 0Dh, 0Ah, 0
buzz_str BYTE "Buzz", 0Dh, 0Ah, 0
fizzbuzz_str BYTE "FizzBuzz", 0Dh, 0Ah, 0

.code
main proc
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov rsi, 1

loop_start:
    cmp rsi, 101
    jge loop_end

    mov rax, rsi
    xor rdx, rdx
    mov rbx, 15
    div rbx
    cmp rdx, 0
    je print_fizzbuzz

    mov rax, rsi
    xor rdx, rdx
    mov rbx, 3
    div rbx
    cmp rdx, 0
    je print_fizz

    mov rax, rsi
    xor rdx, rdx
    mov rbx, 5
    div rbx
    cmp rdx, 0
    je print_buzz

    ; 数値をprintfで出力
    mov rcx, offset format_str
    mov rdx, rsi
    call printf

    jmp loop_continue

print_fizzbuzz:
    mov rcx, offset fizzbuzz_str
    call printf
    jmp loop_continue

print_fizz:
    mov rcx, offset fizz_str
    call printf
    jmp loop_continue

print_buzz:
    mov rcx, offset buzz_str
    call printf
    jmp loop_continue

loop_continue:
    inc rsi
    jmp loop_start

loop_end:
    mov rsp, rbp
    pop rbp
    mov rcx, 0
    call ExitProcess

main endp
end
