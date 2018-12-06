#!/usr/bin/python2.7
import pexpect
import sys

child = pexpect.spawn("git push -u origin master")
child.expect("Username for 'https://github.com':")
child.sendline("jsonhc")
child.expect("Password for 'https://jsonhc@github.com'")
child.sendline("HHq123456*")
child.expect("#")

