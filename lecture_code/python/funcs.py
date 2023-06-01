def add1(lst):
  ret = []
  for x in lst:
    ret.append(x+1)
  return ret

def x2(lst):
  ret = []
  for x in lst:
    ret.append(x*2)
  return ret

def common(lst,f):
  ret = []
  for x in lst: 
    ret.append(f(x)) 
  return ret

def add1(lst):
  return common(lst,lambda x: x + 1)

def x2(lst):
  return common(lst,lambda x: x * 2)

def isEven(lst):
  return common(lst,lambda x: x%2 == 0)

def isEven(lst):
  return common(lst,lambda x: x%2 == 1)

def add1(x):
  return x + 1

def add2(x):
  return x + 2

addtwo = lambda x: x + 2
addtwo(4)

def add(x,y):
  return x + y

def add4():
  return lambda x: x + 4

#add1(3)
print(add1([1,2,3]) == [2,3,4])

(lambda x: lambda y: x + y)

def common(lst,f):
  ret = []
  for x in lst:
    ret.append(f(x))
  return ret

def add1(lst):
  return common(lst,lambda x: x + 1)

add1([1,2,3])
  
common([1,2,3],lambda x: x + 1)
lst = [1,2,3]
f = (lambda x: x +1)
  
ret = [2,3,4]

for x in [1,2,3]:
  ret.append(f(x))

return ret

def reduce(lst,start,comfunc):
  ret = start
  for x in lst:
    ret = comfunc(ret,x)
  return ret

reduce([1,2,3],0,(lambda x,y: x = y))

def a(x):
  return x(2)

let a(x):
  x + 2

let a(x):
  lambda y: x + y

def a(x):
  if x == 1:
    return "hello"
  else:
    returen 23


