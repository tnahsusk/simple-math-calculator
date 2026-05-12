; Simple Math Calculator
; LC3-Based Reverse Polish Notation (RPN) Calculator

; Usage:
; Enter a number 0-9, or an operator +, -, *, or /
; Calculator will use Reverse Polish Notation to calculate
; If there is only one number on stack, operation will fail
; and program will terminate. It will accept up to 4 digits.
; "." will copy the top of the RPN stack into result and terminate
; If stack is empty, operation will fail and program will reset to the beginning

; Algorithm
; 1. Initialize RPN stack and test values 0 - 9, +, -, *, /, and . 
; 2. Print title and instructions
; 3. Read character from keyboard
; 4. If operator, load operator vector, check stack for two numbers 
; 5. If so, execute operator vector and push result on stack, if not, error
; 6. If number, push number onto stack
; 7. If ".", check if stack is empty, if not copy TOS to result, if so, error
; 8. Loop back to 3

; Registers:
; R0 - primary register for operations
; R1 - temp register
; R2 - temp register
; R3 - operator vector for JSRR
; R4 - RPN stack pointer

; Prompts:
;   > - ready to accept a new number
;   ? - error occured, input doesn't make sense
;   $ - stack error occurred
;   ! - numeric overflow or underflow


.orig x3000
START       lea R4, count       ; RPN Stack Pointer Address
            lea R0, MSG1        ; Printing Title and Instruction
            puts
            lea R0, MSG2
            puts
            lea R0, MSG3
            puts

LOOP        lea R0, NEWNUM      ; Asking for a New Number/Operator
            puts
            getc
            lea R0, NEWLINE
            out
            
            ld R1, MULT         ; Setting R1 to "*" and turning it to its negative decimal value
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1      ; If R2 is negative, that means the input is not a valid input (decimal value is too small)
            brn ERROR
            
            ld R1, ASCII_0      ; Setting R1 to ASCII 0 and turning it to its negative decimal value
            not R1, R1
            add R1, R1, #1
            add R2, R0, R1      ; Since we checked the lower bound, anything less than ASCII 0 will be either a valid operator or ","
            brn CHECK_OP
            add R2, R2, #-9     ; If R2 is negative, that means the input is not a valid input (decimal value is too large)
            brn ERROR
            
            ld R1, ASCII_0      ; Resetting R1 to ASCII 0 and turning it to its negative decimal value
            not R1, R1
            add R1, R1, #1
            add R0, R0, R1      ; Converting the ASCII digit to an integer
            str R0, R4, #0      ; Storing the integer in R4 (RPN Stack Pointer)
            add R4, R4, #1      ; Incrementing the R4 and repeating the Loop until CHECK_OP notices a "." or an error occurs
            brnzp LOOP
            halt
            
result      .blkw 1
MULT        .fill x2A
PLUS        .fill x2B
MINUS       .fill x2D
DIVIDE      .fill x2F
TOS         .fill x2E
count       .blkw #8

MSG1        .stringz "SMC RPN Calculator\n"
MSG2        .stringz "Enter 0-9 or +, -, *, /, or . to display result on TOS.\n"
MSG3        .stringz "It will accept up to 4 numeric digits and perform operations.\n"
NEWNUM      .stringz "> "
INPUTERROR  .stringz "? "
STACKERROR  .stringz "$ "
FLOWERROR   .stringz "! "
NEWLINE     .fill xA
.end