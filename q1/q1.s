.extern malloc

.global make_node
.global insert
.global get
.global getAtMost

.text

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0 
    li a0, 24
    call malloc

    sw s0, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)
    
    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret


insert:
    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    sd s1, 0(sp)
    beq a0, x0, empty_tree
    
    mv s0, x0 #parent
    mv s1, a0 #curr

insert_loop:
    beq s1, x0, create_check

    lw t0, 0(s1)
    blt a1, t0, insert_go_left
    j insert_go_right

insert_go_left:
    mv t1, s1
    ld s1, 8(s1)
    mv s0, t1
    j insert_loop

insert_go_right:
    mv t1, s1
    ld s1, 16(s1)
    mv s0, t1
    j insert_loop  

create_check:
    addi sp, sp, -12
    sd a0, 4(sp) #save root in stack
    sw a1, 0(sp) #save val in stack
    mv a0, a1 #arg of make_node
    jal ra, make_node #a0 will store the new node ptr
    lw t3, 0(s0)
    lw a1, 0(sp)
    addi sp, sp, 4
    blt a1, t3, insert_left
    j insert_right

insert_left:
    sd a0, 8(s0)
    j insert_end

insert_right:
    sd a0, 16(s0)
    j insert_end

insert_end:
    ld a0, 0(sp) #restore root
    addi sp, sp, 8

    ld ra, 16(sp)
    ld s0, 8(sp)
    ld s1, 0(sp)
    addi sp, sp, 24
    ret

empty_tree:
    mv a0, a1
    jal ra, make_node #make root

    ld ra, 16(sp)
    ld s0, 8(sp)
    ld s1, 0(sp)
    addi sp, sp, 24
    ret    


get:
    addi sp, sp, -16
    sd ra, 8(sp)
    mv t0, a0

get_loop:
    beq t0, x0, get_end

    lw t1, 0(t0)
    beq t1, a1, get_end
    blt a1, t1, get_go_left
    j get_go_right

get_go_left:
    ld t0, 8(t0)
    j get_loop

get_go_right:
    ld t0, 16(t0)
    j get_loop

get_end:
    mv a0, t0

    ld ra, 8(sp)
    addi sp, sp, 16
    ret


getAtMost:
    addi sp, sp, -16
    sd ra, 8(sp)
    mv t0, a1
    li t2, -1

getAtMost_loop:
    beq x0, t0, getAtMost_end

    lw t1, 0(t0)
    blt t1, a0, getAtMost_go_right
    beq t1, a0, getAtMost_go_right
    j getAtMost_go_left

getAtMost_go_left:
    ld t0, 8(t0)
    j getAtMost_loop

getAtMost_go_right:
    lw t2, 0(t0)
    ld t0, 16(t0)
    j getAtMost_loop

getAtMost_end:
    mv a0, t2

    ld ra, 8(sp)
    addi sp, sp, 16
    ret
