.data
    filename:   .asciz "input.txt"
    mode_r:     .asciz "r"
    yes_str:    .asciz "Yes\n"
    no_str:     .asciz "No\n"

.text
.global main

.extern fopen
.extern fclose
.extern fseek
.extern fgetc
.extern ftell

main:
    addi sp, sp, -56
    sd ra, 48(sp)
    sd s0, 40(sp)  #file ptr
    sd s1, 32(sp)  #left
    sd s2, 24(sp)  #right
    sd s3, 16(sp)  #left char
    sd s4, 8(sp)   #right char

    la a0, filename
    la a1, mode_r
    call fopen
    mv s0, a0           

    mv a0, s0
    li a1, 0
    li a2, 2  #end
    call fseek

    mv a0, s0
    call ftell
    addi s2, a0, -1 #s2=right=size-1
    li s1, 0  #s1=left=0

loop:
    bge s1, s2, print_yes

    mv a0, s0
    mv a1, s1 #offset=left index
    li a2, 0         
    call fseek

    mv a0, s0
    call fgetc
    mv s3, a0          

    mv a0, s0
    mv a1, s2 #offset=right index
    li a2, 0            
    call fseek

    mv a0, s0
    call fgetc
    mv s4, a0          

    bne s3, s4, print_no

    addi s1, s1, 1     
    addi s2, s2, -1    
    j loop

print_yes:
    mv a0, s0
    call fclose
    la a0, yes_str
    call printf
    j end

print_no:
    mv a0, s0
    call fclose
    la a0, no_str
    call printf

end:
    ld ra, 48(sp)
    ld s0, 40(sp)
    ld s1, 32(sp)
    ld s2, 24(sp)
    ld s3, 16(sp)
    ld s4, 8(sp)
    addi sp, sp, 56
    li a0, 0
    ret

