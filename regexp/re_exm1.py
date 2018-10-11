#!/usr/bin/python3
import re
content="hello world,my name is wadeson"
print(content)
result=re.match(r'hello (\w)+',content)
print(result)
print(result.group())
print(result.group(1))
print(result.span())
