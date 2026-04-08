.data
    output_format: .asciz "%lld "

.extern printf
.extern malloc
.global atoi

.global main

.text

main:
    addi sp, sp, -64      
    sd ra, 56(sp)
    sd s5, 48(sp)
    sd s4, 40(sp)
    sd s3, 32(sp)
    sd s2, 24(sp)
    sd s1, 16(sp)
    sd s0, 8(sp)

    addi a0, a0, -1
    mv s0, a0  #array len
    addi a1, a1, 1
    mv s4, a1 #argv ptr
    mv a0, s0
    slli a0, a0, 3
    call malloc
    mv s1, a0 #array ptr
    mv s5, s1
    mv t0, s0 #array len
    mv t2, s0 #array len

traverse:
    beq t0, x0, allocate_result
    ld a0, 0(s4)
    sd t0, 0(sp)      
    call atoi
    ld t0, 0(sp)      
    sd a0, 0(s5)
    addi s4, s4, 8
    addi s5, s5, 8
    addi t0, t0, -1
    j traverse

allocate_result:
    mv a0, s0
    slli a0, a0, 3
    call malloc
    mv s2, a0 #result ptr

allocate_stack:
    mv a0, s0
    slli a0, a0, 3
    call malloc
    mv s3, a0 #stack ptr
    li t1, -1 #stack -> empty (stack len = t1+1)
    mv t2, s0 #array len

for_loop: 
    beq t2, x0, print
    addi t2, t2, -1 #(t2=i)

while_loop:
    addi t3, t1, 1
    beq t3, x0, cond_push #stack empty
    ld t3, -8(s3) #stack top
    slli t3, t3, 3
    add t3, t3, s1
    ld t3, 0(t3) #arr[stack.top()]
    slli t4, t2, 3
    add t4, t4, s1
    ld t4, 0(t4) #arr[i]
    blt t4, t3, cond_push    
    addi s3, s3, -8
    addi t1, t1, -1
    j while_loop

store_result:
    mv t5, t2
    slli t5, t5, 3
    add t5, t5, s2 #result[i]
    ld t6, -8(s3) #stack.top()
    sd t6, 0(t5)
    j push

cond_push:
    addi t3, t1, 1
    bne t3, x0, store_result #if_cond
    mv t5, t2
    slli t5, t5, 3
    add t5, t5, s2 #result[i]
    li t6, -1
    sd t6, 0(t5)

push:
    addi s3, s3, 8
    sd t2, -8(s3)
    addi t1, t1, 1
    j for_loop

print:
    beq s0, x0, end
    addi s0, s0, -1
    la a0, output_format
    ld t6, 0(s2)
    addi s2, s2, 8 
    mv a1, t6
    call printf
    j print

end:
    ld ra, 56(sp)
    ld s5, 48(sp)
    ld s4, 40(sp)
    ld s3, 32(sp)
    ld s2, 24(sp)
    ld s1, 16(sp)
    ld s0, 8(sp)
    addi sp, sp, 64
    ret
    