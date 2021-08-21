.data
msg1: .asciiz "Please enter integer x: "
msg2: .asciiz "Please enter integer y: "
msg3: .asciiz "The result is: " 
.text

.globl main
main:

li	$v0, 4
la	$a0, msg1
syscall

li	$v0, 5
syscall
move	$t0, $v0

li	$v0, 4
la	$a0, msg2
syscall

li	$v0, 5
syscall
move	$t1, $v0

move	$a0, $t0
move	$a1, $t1

jal	GCD
move	$t0, $v0

li	$v0, 4
la	$a0, msg3
syscall

li	$v0, 1
move	$a0, $t0
syscall

li	$v0, 10
syscall


GCD:
addi	$sp, $sp, -4
sw	$ra, 0($sp)

# make the order correct
slt	$t3, $a1, $a0
bne	$t3, $zero, start
move	$t0, $a0
move	$a0, $a1
move	$a1, $t0

start:
beq	$a1, $zero, EXIT

move	$s0, $a0
LOOP:
sub	$s0, $s0, $a1
slt	$t0, $s0, $a1
beq	$t0, $zero, LOOP

move	$a0, $a1
move	$a1, $s0
jal	start


EXIT:
move	$v0, $a0
lw	$ra, 0($sp)
addi	$sp, $sp, 4
jr	$ra



