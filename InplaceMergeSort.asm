################################################################################## 
# Assignment - Problem 3
# Group L01 - 12:
#     Pham Thi Hong Hieu
#
#
#     Tran Ha Tuan Kiet
#	Id: 2011493
#	Email: kiet.trank1netic@hcmut.edu.vn
# Implementation of Merge sort using recursion, no more than 1 array is use. 
##################################################################################
#Data segment
	.data
fileName:	.asciiz		"FLOAT15.BIN"
size:		.word		15
array:		.space  	60
# Statements for Data input 
prompt_before:	.asciiz	"Before sorting: "
prompt_after:	.asciiz	" After sorting: "
#Code segment
	.text
	.globl	main
main:

#------------------Input-----------------#
	li	$v0, 13			# open file code = 13
	la	$a0, fileName		# get the file name
	li	$a1, 0			# set flag = 0 (read file: 0, write flie: 1) 
	li	$a2, 0			# mode ignored
	syscall
	move	$s0, $v0
	
	# read data
	li	$v0, 14			# read file code = 14
	move	$a0, $s0		# file descriptor
	la	$a1, array		# the buffer holding
	la	$a2, 60			# hardcoded buffer length, 60 = 15 * 4 = no_elements * sizeof(float)
	syscall
	
	# close file
	li	$v0, 16			# close file code = 16
	move	$a0, $s0		# file descriptor to close
	syscall
# print
	la	$a0, prompt_before	# load prompt address
	li	$v0, 4			# ready to print string prompt 
	syscall

	jal	printArray		# call function to print float array

endfor1:
#---------------Process-------------#
# Call mergeSort(array, 0, size - 1) 
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

	jal	printArray		# call function to print float array
endfor2:
	
	li	$v0, 10
	syscall

#############################################################
# function mergeSort(array, left, right)
# a0: array   
# a1: left     
# a2: right
# No output
# Description: Recursively sort an array from left to right 
#############################################################

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
	
	addi 	$a0, $zero, '\n'
	li	$v0, 11
	syscall
	jal	printArray
#call	mergeSort(array, mid + 1, right)
	lw	$a0,  0($sp)
	lw	$a1, 12($sp)
	addi	$a1, $a1, 1
	lw	$a2, 8($sp)
	jal 	mergeSort
	
	addi 	$a0, $zero, '\n'
	li	$v0, 11
	syscall
	jal	printArray	
#call	merge(array, start, mid, end)
	lw	$a0,   0($sp)
	lw	$a1,   4($sp)
	lw	$a2,  12($sp)
	lw	$a3,   8($sp)
	jal	merge
	
	addi 	$a0, $zero, '\n'
	li	$v0, 11
	syscall
	jal	printArray
	
endif1:
	lw	$ra, 16($sp)
	lw	$a0,  0($sp)
	lw	$a1,  4($sp)
	lw	$a2,  8($sp)
	addi	$sp, $sp, 20
	jr	$ra

#################################################################
# function merge(array, start, mid, end)
# a0: array
# a1: start
# a2: mid
# a3: end 
# No output
# Description: merge 2 sub-arrays which are (nearly) the same size
# by choosing between 2 beginning elements of 2 sub-arrays which 
# one is smaller, then popping out.
#################################################################
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

begin_while:
	slt	$t0, $a2, $a1		# mid < start
	slt	$t1, $a3, $		# end < start_r
	or	$t0, $t0, $t1		# (... || ...)
	bnez	$t0, end_while		# => while !(..) 
#begin_do
# s1 = arr + start, s2 = arr + start_r
	sll	$t2, $a1, 2		# calculate start x float block 
	add	$s1, $a0, $t2		# arr + start
	lwc1	$f0, 0($s1)		# f0 = arr[start]
	sll	$t2, $s0, 2		# calculate start_r x float block 
	add	$s2, $a0, $t2		# arr + start_r
	lwc1	$f1, 0($s2)		# f1 = arr[start_r]
	
#begin_if2  if (arr[start] <= arr[start_r]
	c.le.s	$f0, $f1
	bc1f if_false2
if_true2:
	addi	$a1, $a1, 1 		# start++ 
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
	swc1	$f1, 0($s1)		#arr[start] = tmp
	addi	$a1, $a1, 1		#start++
	addi	$a2, $a2, 1		#mid++
	addi	$s0, $s0, 1		#start_r++
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


#####################################
# function printArray()
printArray:
# preserve a0
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
#------------------------------------------------#
	# s0 = size, a0 = array
	la	$s0, array
	lw	$s1, size
	sll	$s1, $s1, 2
	add	$s1, $s0, $s1
	# for (i = 0; i < size; i++)
cond:
	beq	$s0, $s1, endfor
#begin_loop:
	addi 	$a0, $zero, ' '
	li	$v0, 11
	syscall

	lwc1	$f12, 0($s0)		# load float to f12 to print
	li	$v0, 2			# code 2 to print float
	syscall
#end_loop:
	addi	$s0, $s0, 4
	j	cond
endfor:
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
