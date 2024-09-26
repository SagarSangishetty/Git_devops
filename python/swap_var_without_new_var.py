num1=20
num2=10

if num1 < num2:
    print("Numbers before swap:\n", num1,num2)
    num1=num1+num2
    num2=num1-num2
    num1=num1-num2
    print("Numbers after swap:\n",num1,num2)

elif num2 < num1:
    print("Numbers before swap:\n", num1,num2)
    num1=num1-num2
    num2=num2+num1
    print("Numbers after swap:\n",num1,num2)
    
