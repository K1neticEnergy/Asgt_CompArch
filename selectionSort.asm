################################################################################## 
# Assignment - Problem 3
# Group L01 - 09:
#     Tran Ha Tuan Kiet
#	Id: 2011493
#	Email: kiet.trank1netic@hcmut.edu.vn
#
#     <Your name Here>
#	Id: 2020025
#
# Implementation of Selection sort. 
##################################################################################
#Data segment
	.data
fileName:	.asciiz		"FLOAT10.BIN"
size:		.word		10
array:		.space  	40
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
	li	$a1, 0			# set flag = 0 (read file: 0, write file: 1) 
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
	addi	$sp, $sp, -20	# initiate stack
	sw	$a0, 0($sp)	# save array address
	sw	$a1, 4($sp)	# save left
	sw	$a2, 8($sp)	# save right
	sw	$ra, 16($sp)
#----------------------------#

## TODO

#----------------------------#
# Reset stack pointer
	lw	$ra, 16($sp)
	lw	$a0,  0($sp)
	lw	$a1,  4($sp)
	lw	$a2,  8($sp)
	addi	$sp, $sp, 20
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
	lw	$s1, size		# Load size of array to $s1 = size = 15
	sll	$s1, $s1, 2		# byte offset from arr[0] to arr[14]
	add	$s1, $s0, $s1		# add offset to the address of arr[0]; $s1 = addr of arr[14]
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

