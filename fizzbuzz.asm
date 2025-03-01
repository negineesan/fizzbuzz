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
    ; Debug: print "start"
    sub rsp, 28h
    lea rdx, start_msg
    mov rcx, std_out_handle
    mov r8, sizeof start_msg -1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    ; End Debug

    push rbp
    mov rbp, rsp
    and rsp, -10h

    mov rcx, -11
    call GetStdHandle
    mov std_out_handle, rax
    
    sub rsp, 28h
    lea rdx, start_msg
    mov rcx, rax
    mov r8, sizeof start_msg - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h

    ; Debug: print rsi
    sub rsp, 32
    mov rax, 1
    call convert_to_string
    mov rdx, rax
    mov r8, rcx
    mov rcx, std_out_handle
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 32

    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, newline
    mov r8, sizeof newline - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    ; End Debug

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

    jmp print_number

print_fizzbuzz:
    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, fizzbuzz_str
    mov r8, sizeof fizzbuzz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    jmp print_newline

print_fizz:
    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, fizz_str
    mov r8, sizeof fizz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    jmp print_newline

print_buzz:
    sub rsp, 28h
    mov rcx, std_out_handle
    lea rdx, buzz_str
    mov r8, sizeof buzz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 28h
    jmp print_newline

print_number:
    sub rsp, 32
    mov rax, rsi
    call convert_to_string

    mov rdx, rax
    mov r8, rcx
    mov rcx, std_out_handle
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 32

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

convert_to_string proc
    sub rsp, 32
    mov rdi, rsp
    mov rcx, 0

    mov rbx, 10
    test rax, rax
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
    mov rax, rdi
    ret
convert_to_string endp

main endp
end
