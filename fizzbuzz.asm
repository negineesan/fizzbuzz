.code
extrn ExitProcess: proc
extrn GetStdHandle: proc
extrn WriteConsoleA: proc
extrn GetLastError: proc

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
    sub rsp, 32

    mov rcx, -11
    call GetStdHandle
    mov std_out_handle, rax

    lea rdx, start_msg
    mov rcx, std_out_handle
    mov r8, sizeof start_msg - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA

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
    call write_fizzbuzz
    jmp print_newline

print_fizz:
    call write_fizz
    jmp print_newline

print_buzz:
    call write_buzz
    jmp print_newline

print_number:
    call write_number
    jmp print_newline

print_newline:
    call write_newline
    inc rsi
    jmp loop_start

loop_end:
    mov rsp, rbp
    pop rbp
    mov rcx, 0
    call ExitProcess

write_fizzbuzz proc
    sub rsp, 32
    mov rcx, std_out_handle
    lea rdx, fizzbuzz_str
    mov r8, sizeof fizzbuzz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 32
    ret
write_fizzbuzz endp

write_fizz proc
    sub rsp, 32
    mov rcx, std_out_handle
    lea rdx, fizz_str
    mov r8, sizeof fizz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 32
    ret
write_fizz endp

write_buzz proc
    sub rsp, 32
    mov rcx, std_out_handle
    lea rdx, buzz_str
    mov r8, sizeof buzz_str - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 32
    ret
write_buzz endp

write_newline proc
    sub rsp, 32
    mov rcx, std_out_handle
    lea rdx, newline
    mov r8, sizeof newline - 1
    lea r9, bytes_written
    push 0
    call WriteConsoleA
    add rsp, 32
    ret
write_newline endp

write_number proc
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
    ret
write_number endp

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
    xor rdx,rdx
    div rbx
    add dl, '0'
    mov [rdi+rcx], dl
    inc rcx
    test rax,rax
    jnz convert_loop

    mov rax, rdi
    lea rbx, [rdi+rcx-1]
reverse_loop:
    cmp rdi,rbx
    jge convert_done
    mov dl,[rdi]
    mov dh,[rbx]
    mov [rdi],dh
    mov [rbx],dl
    inc rdi
    dec rbx
    jmp reverse_loop

convert_done:
    mov rcx, rcx
    ret
convert_to_string endp

main endp
end
