# ---------------------------------------------------------
# Brandon Burke 712
# cs286 - 001
# fujinoki
# ---------------------------------------------------------
.data

str1:    .asciiz "Enter first integer (1-9999): "
str2:    .asciiz "Enter Secodn integer (1-9999): "
counter: .asciiz "Recursive Round: "
str4:    .asciiz "The GCD is:  "
ER:      .asciiz "invalid input\n"
newline: .asciiz "\n"

.globl main
.text

main:
# ---------------------------------------------------------
# input 1
# ---------------------------------------------------------
 input1:   
    li $v0, 4
    la $a0, str1
    syscall
    li $v0, 5
    syscall
    move $t1, $v0
    li $v0, 1
	blt $t1, $v0, ER1
    li $v0, 9999
	bgt $t1, $v0, ER1
        j success1
ER1:
    li $v0, 4
    la $a0, ER
    syscall
    j input1
success1:
# ---------------------------------------------------------
# input 2
# ---------------------------------------------------------
input2:
    la $a0, str2
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t2, $v0
    li $v0, 1
	blt $t2, $v0, ER2
    li $v0, 9999
	bgt $t2, $v0, ER2
        j success2
ER2:
    li $v0, 4
    la $a0, ER
    syscall
    j input2
success2:
    li $v0, 4
    la $a0, newline
    syscall
# ---------------------------------------------------------
# gcd subroutine
# ---------------------------------------------------------
    addi $sp, $sp, -8      # allocates space for two registers in the stack
    sw $t1, 4($sp)         # save t1
    sw $t2, 0($sp)         # save t2
    jal gcd                # jump and link to the subroutine gcd
    lw $t2, 0($sp)         # restore t2
    lw $t1, 4($sp)         # restore t1
    addi $sp, $sp, 8       # clean stack
    li $t4, 0              # cleans counter 
# ---------------------------------------------------------
# output gcd
# ---------------------------------------------------------
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 4
    la $a0, str4
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0,4
    la $a0,newline
    syscall     
# ---------------------------------------------------------
# exits program
# ---------------------------------------------------------
exit:
    li $v0, 10
    syscall
	jr $31
# ---------------------------------------------------------
# Calculates the greatest common divisor
# ---------------------------------------------------------
gcd:
    addi $sp, $sp, -8           # adds 2 registers to the stack
    sw $ra, 0($sp)              # save return address
    sw $s0, 4($sp)              # save the remainder
    div $t1, $t2                # t1/t2 with $rd
    mfhi $s0                    # s0 = $rd
# ---------------------------------------------------------
# terminating condition
# ---------------------------------------------------------
    bne $s0, $zero, subRout     # recurse if $s0 != 0
        move $v0, $t2           # t2 holds result, store in $v0
        addi $sp, $sp, 8        # remove 2 registers from the stack
        jr $ra                  # return to previous address
subRout:
# ---------------------------------------------------------
# counter 
# ---------------------------------------------------------
    addi $t4,$t4,1
    li $v0, 4
    la $a0, counter
    syscall
    li $v0,1
    move $a0,$t4
    syscall           
    li $v0,4
    la $a0,newline
    syscall           
# ---------------------------------------------------------
# gcd algorithm
# ---------------------------------------------------------
    move $t1, $t2               # set t2 to t2
    move $t2, $s0               # set t2 to rd
    jal gcd                     # recursive call
# ---------------------------------------------------------
# return and exit
# ---------------------------------------------------------
    lw $ra, 0($sp)              # load first return address
    lw $s0, 4($sp)              # load remainder
    addi $sp, $sp, 8            # remove 2 registers from the stack
    jr $ra                      # return
# ---------------------------------------------------------
# end of recursion
# ---------------------------------------------------------
