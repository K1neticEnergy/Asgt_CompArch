################################################################################## 
# Assignment - Problem 9
# Group L01 - 09:
#     Tran Ha Tuan Kiet
#	Id: 2011493
#	Email: kiet.trank1netic@hcmut.edu.vn
#
#     Quach Minh Duc
#	Id: 2010231
#	Email: duc.quacho19@hcmut.edu.vn
# Implementation of Selection sort. 
##################################################################################
#Data segment
	.data
fileName:	.asciiz		"F:/Minh Duc/STUDY/HCMUT/Sophomore/212/CA/BTL/Asgt_CompArch/FLOAT10.BIN"
size:		.word		10
array:		.space  	40
# Statements for Data input 
prompt_before:	.asciiz	"Before sorting: "
prompt_after:	.asciiz	" After sorting: "
step:		.asciiz "	Step "
colon:		.asciiz ": "
#Code segment
	.text
	.globl	main
main:

#------------------Input-----------------#
	li	$v0, 13			# open file code = 13
	la	$a0, fileName		# get the file name
	li	$a1, 0			# set flag = 0 (read file: 0, write file: 1) 
	li	$a2, 0			# mode ignored
	syscall
	move	$s0, $v0
	
	# read data
	li	$v0, 14			# read file code = 14
	move	$a0, $s0		# file descriptor
	la	$a1, array		# the buffer holding
	la	$a2, 40			# hardcoded buffer length, 40 = 10 * 4 = no_elements * sizeof(float)
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
# Call selectionSort(array, 0, size - 1) 
	la	$a0, array
	add	$a1, $zero, $zero
	lw	$a2, size
	addi	$a2, $a2, -1
	jal	selectionSort

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
# function selectionSort(array, left, right)
# a0: array   
# a1: left     
# a2: right
# No output
# Description: sort an array from left to right 
#############################################################

selectionSort:
# Set stack pointer
	addi	$sp, $sp, -16		# initiate stack
	sw	$a0, 0($sp)		# save array address
	sw	$a1, 4($sp)		# save left
	sw	$a2, 8($sp)		# save right
	sw	$ra, 12($sp)
#----------------------------#
	# t0 = a0 = array address, t1 = a1 = left, t2 = a2 = right
	add	$t0, $a0, $zero		# array address
	add 	$t1, $a1, $zero		# left
	add	$t2, $a2, $zero		# right
	
	# while (left < right) sort
sort_cond:
	slt	$t3, $t1, $t2
	beq 	$t3, $zero, exit_sort
	
	add	$a0, $t0, $zero
	add	$a1, $t1, $zero
	add	$a2, $t2, $zero
	jal	findMin			# find the index of min value
	
	# if (index of min value == left) skip
	add	$t4, $v0, $zero		# t4 holds the index of min value
	beq	$t4, $t1, sort_iterate
	
	# Swap arr[left] and arr[index]
	sll	$t5, $t1, 2	
	add	$t5, $t0, $t5		# location of arr[left]
	lwc1	$f1, 0($t5)		# f1 holds the value of arr[left]
	
	sll	$t6, $t4, 2	
	add	$t6, $t0, $t6		# location of arr[index]
	lwc1	$f2, 0($t6)		# f2 holds the value of arr[index]
	
	swc1	$f1, 0($t6)
	swc1	$f2, 0($t5)
	
	#Print the array after being changed
	addi 	$a0, $zero, '\n'
	li	$v0, 11
	syscall

	la	$a0, step
	li	$v0, 4
	syscall
	
	addi	$a0, $t1, 1
	li	$v0, 1
	syscall
	
	la	$a0, colon
	li	$v0, 4
	syscall
	
	add	$a0, $t0, $zero		# a0 holds the array address
	jal	printArray

sort_iterate:
	addi	$t1, $t1, 1		# left++
	j	sort_cond
#----------------------------#
exit_sort:
# Reset stack pointer
	lw	$ra, 12($sp)
	lw	$a0,  0($sp)
	lw	$a1,  4($sp)
	lw	$a2,  8($sp)
	addi	$sp, $sp, 16
	jr	$ra

#####################################
# function printArray()
# a0 : array
# No output
# Description: print an array, delimited by ' '
#####################################
printArray:
# preserve a0
	addi	$sp, $sp, -8
	sw	$a0, 0($sp)		# Preserve the address $a0 of array
	sw	$ra, 4($sp)
#------------------------------------------------#
	# s0 = size, a0 = array
	la	$s0, array		# Load the address of array to $s0
	lw	$s1, size		# Load size of array to $s1 = size = 10
	sll	$s1, $s1, 2		# byte offset from arr[0] to arr[9]
	add	$s1, $s0, $s1		# add offset to the address of arr[0]; $s1 = addr of arr[9]
	# for (i = 0; i < size; i++)
cond:
	beq	$s0, $s1, endfor	# if (i ($s0) < size ($s1)), jump to endfor
#begin_loop:
	addi 	$a0, $zero, ' '		# Load a space character to $a0
	li	$v0, 11			# Print a space
	syscall

	lwc1	$f12, 0($s0)		# load float to f12 to print
	li	$v0, 2			# code 2 to print float
	syscall
#end_loop:
	addi	$s0, $s0, 4		# Move 4 bytes to the address of arr[i+1]
	j	cond
endfor:
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra


#####################################
# function findMin()
# a0: array address
# a1: left
# a2: right
# Output v0: index of min value
# Description: find the index of the minimum value in a given array
#####################################
findMin:
# Set stack pointer
	addi	$sp, $sp, -16		# initiate stack
	sw	$a0, 0($sp)		# save array address
	sw	$a1, 4($sp)		# save left
	sw	$a2, 8($sp)		# save right
	sw	$ra, 12($sp)
#----------------------------#
	# s0 = a0 = array address, s1 = a1 = left, s2 = a2 = right
	add	$s0, $a0, $zero		# array address
	add 	$s1, $a1, $zero		# left, index of the min value
	add	$s2, $a2, $zero		# right
	addi	$s3, $a1, 1		# temp var used to check the condition, initially set to the left value
min_cond:
	# while (temp <= right) findMin
	sub	$s4, $s2, $s3		
	blt	$s4, $zero, min_exit
	
	sll	$s5, $s1, 2		
	add	$s5, $s0, $s5		# location of arr[index]
	lwc1	$f1, 0($s5)		# f1 holds the value of arr[index]
	
	sll	$s5, $s3, 2		
	add	$s5, $s0, $s5		# location of arr[temp]
	lwc1	$f2, 0($s5)		# f2 holds the value of arr[temp]
	
	# compare arr[temp] and arr[index]
	c.lt.s	$f2, $f1		# if arr[temp] < arr[index] then min = temp and temp++
	bc1f	min_iterate		
	add	$s1, $s3, $zero		
min_iterate:
	addi	$s3, $s3, 1		# else temp++
	j	min_cond
min_exit:
	add	$v0, $s1, $zero		# v0 holds the value of the index
#----------------------------#
# Reset stack pointer
	lw	$ra, 12($sp)
	lw	$a0,  0($sp)
	lw	$a1,  4($sp)
	lw	$a2,  8($sp)
	addi	$sp, $sp, 16
	jr	$ra
