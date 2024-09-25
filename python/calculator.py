#To list the calculator operation to perform
functionality=["Addition","Substraction","Division","Multiplication"]
print("Calculator will perform below action only")
for i in functionality:
    print(i)

operation_to_perform=input("Enter any one from above list\n")

if operation_to_perform in functionality:
    print (f"{operation_to_perform} operation is performed")
else:
     print (f"{operation_to_perform} operation entered is incorrect")

print ("Enter two numbers to perform",f"{operation_to_perform}")

num_1=int(input("Enter first number\n"))
num_2=int(input ("Enter second number\n"))

if functionality[0] == operation_to_perform:
    result = num_1 + num_2
    print(f"The sum of number is {result}")
elif functionality[1] == operation_to_perform:
    result = num_1 - num_2
    print(f"The substraction of number is {result}")
elif functionality[2] == operation_to_perform:
    result = num_1 / num_2
    print(f"The division of number is {result}")
elif functionality[3] == operation_to_perform:
    result = num_1 * num_2
    print(f"The multilpliation of number is {result}")
