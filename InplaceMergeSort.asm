# Merge sort
# Comparison sort
# Use recursion
# 
#Data segment
	.data
size:	.word	15
array:	.float	20.0 68.0 4.0 7.0 164.0 15.0 32.0 525.0 56.0 70.0 6.0 90.0 5.0 123.0 40.0
# Statements for Data input 
prompt_before:	.asciiz	"Before sorting: "
prompt_after:	.asciiz	" After sorting: "
#Code segment
	.text
	.globl	main
main:

#------------------Input-----------------#
	la	$a0, prompt_before
	li	$v0, 4
	syscall

# s0 = size, a0 = array, t0 = i (= 0)
	la	$s0, array
	addi	$t0, $zero, 0
	lw	$s1, size
# for (i = 0; i < size; i++)
cond1:	
	beq	$t0, $s1, endfor1
#begin_loop:
	addi 	$a0, $zero, ' '
	li	$v0, 11
	syscall

	lwc1	$f12, 0($s0)	# load float to f12 to print
	li	$v0, 2		# code 2 to print float
	syscall
#end_loop:
	addi	$s0, $s0, 4
	addi	$t0, $t0, 1
	j	cond1
endfor1:
#---------------Process-------------#

	la	$a0, array
	add	$a1, $zero, $zero
	lw	$a2, size
	addi	$a2, $a2, -1
	jal	mergeSort

#---------------Output--------------#
	addi 	$a0, $zero, '\n'
	li	$v0, 11
	syscall

	la	$a0, prompt_after
	li	$v0, 4
	syscall

# s0 = size, a0 = array, t0 = i (= 0)
	la	$s0, array
	addi	$t0, $zero, 0
	lw	$s1, size
# for (i = 0; i < size; i++)
cond2:	
	beq	$t0, $s1, endfor2
#begin_loop:
	addi 	$a0, $zero, ' '
	li	$v0, 11
	syscall

	lwc1	$f12, 0($s0)	# load float to f12 to print
	li	$v0, 2		# code 2 to print float
	syscall
#end_loop:
	addi	$s0, $s0, 4
	addi	$t0, $t0, 1
	j	cond2
endfor2:
	
	li	$v0, 10
	syscall

######################
# function mergeSort #
# Inp: a0 = array    #
#      a1 = left     #
#      a2 = right    #
######################

mergeSort:
# Set stack pointer
	addi	$sp, $sp, -20
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$ra, 16($sp)
#----------------------------#
# t0 = left, t1 = right
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)

#if (left < right)
	bge	$t0, $t1, endif1

# s0 = mid = left + (right - left) / 2 = t0 + (t1 - t0) / 2
	sub	$s0, $t1, $t0
	srl	$s0, $s0, 1
	add	$s0, $s0, $t0
	sw	$s0, 12($sp)
	
#call 	mergeSort(array, left, mid)
	lw	$a0,  0($sp)
	lw	$a1,  4($sp)
	lw	$a2, 12($sp) 
	jal 	mergeSort

#call	mergeSort(array, mid + 1, right)
	lw	$a0,  0($sp)
	lw	$a1, 12($sp)
	addi	$a1, $a1, 1
	lw	$a2, 8($sp)
	jal 	mergeSort
	
#call	merge(array, start, mid, end)
	lw	$a0,   0($sp)
	lw	$a1,   4($sp)
	lw	$a2,  12($sp)
	lw	$a3,   8($sp)
	jal	merge
	
endif1:
	lw	$ra, 16($sp)
	lw	$a0,  0($sp)
	lw	$a1,  4($sp)
	lw	$a2,  8($sp)
	addi	$sp, $sp, 20
	jr	$ra

##########################################
# function merge(array, start, mid, end)
##########################################
merge:
	addi	$sp, $sp, -16
	sw	$a1,  0($sp)
	sw	$a2,  4($sp)
	sw	$a3,  8($sp)
	sw	$ra, 12($sp)
#----------------------------------------#
# s0 = start_r, a1 = start, a2 = mid, a3 = end
	addi	$s0, $a2, 1
	sll	$t0, $a2, 2
	add	$t0, $a0, $t0 	# t0 = array + mid
	lwc1	$f0, 0($t0)	# f1 = (*t0) 
	
	sll	$t0, $s0, 2
	add	$t0, $a0, $t0	# t0 = array + start_r
	lwc1	$f1, 0($t0)	# f2 = (*t0)
# if (arr[mid] <= arr[start_r]) 
	c.le.s	$f0, $f1
	bc1t	return
# while (start <= mid && start_r <= end)
# !mid < start
# !end < start_r
# !(... || ...) 
begin_while:
	slt	$t0, $a2, $a1
	slt	$t1, $a3, $s0
	or	$t0, $t0, $t1
	bnez	$t0, end_while
#begin_do
# s1 = arr + start, s2 = arr + start_r
	sll	$t2, $a1, 2
	add	$s1, $a0, $t2
	lwc1	$f0, 0($s1)	# f0 = arr[start]
	sll	$t2, $s0, 2
	add	$s2, $a0, $t2
	lwc1	$f1, 0($s2)	# f1 = arr[start_r]
	
#begin_if2  if (arr[start] <= arr[start_r]
	c.le.s	$f0, $f1
	bc1f if_false2
if_true2:
	addi	$a1, $a1, 1 # start++ 
	j	end_if2
if_false2:
#reuse f1 for temp = arr[start_r]
#begin_for 
cond3:
	sub	$t0, $s2, $s1
	beqz	$t0, end_for3
#begin_loop: arr[i] = arr[i - 1]
	lwc1	$f0, -4($s2)
	swc1	$f0, 0($s2)
#end_loop:
	addi	$s2, $s2, -4
	j	cond3
end_for3:
	swc1	$f1, 0($s1)	#arr[start] = tmp
	addi	$a1, $a1, 1	#start++
	addi	$a2, $a2, 1	#mid++
	addi	$s0, $s0, 1	#start_r++
end_if2:
	j 	begin_while
#end_do
end_while:
return:
	lw	$a1,  0($sp)
	lw	$a2,  4($sp)
	lw	$a3,  8($sp)
	lw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra
