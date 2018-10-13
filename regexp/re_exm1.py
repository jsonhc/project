#!/usr/bin/python3
import re
content="hello world,my name is wadeson"
print(content)
result=re.match(r'hello (\w)+',content)
print(result)
print(result.group())
print(result.group(1))

result=re.match(r'world',content)   # match方法一定是从开头开始匹配,如果开头匹配不到就返回None
print(result)

result=re.search(r'world',content)   # search方法,只需要匹配到了就有相应的匹配结果,没匹配到就返回None
print(result.group())


# for 特殊字符需要转义
>>> content="price is $5.00"
>>> import re
>>> result=re.match('price is $5.00',content)
>>> print(result)
None
>>> result=re.match(r'price is $5.00',content)
>>> print(result)
None
>>> result=re.match(r'price is \$5.00',content)
>>> print(result)
<_sre.SRE_Match object; span=(0, 14), match='price is $5.00'>
>>> print(result.group())
price is $5.00


# re.findall() 返回一个列表,但是注意匹配的时候需要加上括号
>>> html = '''
...   <div>
...   <li><a href="" singer="鲁迅">呐喊</a></li>
...   <li><a href="#" singer="贾平凹">废都</a></li>
...   <li class="active"><a href="#" singer="路遥">平凡世界</a></li>
...   <span class="rightSpan">谢谢支持</span>
...   </div>
... '''
>>> print(html)
>>> result=re.findall('<a.*>.*</a>',html)
>>> print(result)
['<a href="" singer="鲁迅">呐喊</a>', '<a href="#" singer="贾平凹">废都</a>', '<a href="#" singer="路遥">平凡世界</a>']
>>> result=re.findall('<a.*>(.*)</a>',html)
>>> print(result)
['呐喊', '废都', '平凡世界']
>>> for i in result:
...   print(i)
...
呐喊
废都
平凡世界


# re.compile()结合re.findall()一起使用,re.compile()使用pattern模式匹配
pattern=re.compile(r'wang\w')
result=pattern.findall(content)

>>> content ='Hello 123 4567 wangyanling REDome wangyanling 那小子很帅'
>>> rr=re.compile(r'wang\w')
>>> result=rr.findall(content)
>>> print(result)
['wangy', 'wangy']
>>> rr=re.compile(r'wang\w*')
>>> result=rr.findall(content)
>>> print(result)
['wangyanling', 'wangyanling']

