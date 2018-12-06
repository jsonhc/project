#!/usr/bin/python2.7
import pexpect

child = pexpect.spawn("git push -u origin master")
child.expect("Username*")
child.sendline("jsonhc")
child.expect("Password*")
child.sendline("HHq123456*")

