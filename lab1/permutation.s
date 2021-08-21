.data
msg1: .asciiz "Please input integer n: "
msg2: .asciiz "Please input integer k: "
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

jal	PER
move	$t0, $v0

li	$v0, 4
la	$a0, msg3
syscall

li	$v0, 1
move	$a0, $t0
syscall

li	$v0, 10
syscall


PER:
addi	$sp, $sp, -4
sw	$ra, 0($sp)

addi	$v0, $zero, 1
move	$s1, $zero
Loop:
beq	$s1, $a1, EXIT
sub	$t1, $a0, $s1
mul	$v0, $v0, $t1
addi	$s1, $s1, 1
jal	Loop

EXIT:
lw	$ra, 0($sp)
addi	$sp, $sp, 4
jr	$ra

