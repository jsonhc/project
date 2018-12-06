#!/usr/bin/python2.7
import pexpect
import sys
import subprocess

cmd = "git add --all"
p = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()
cmd1 = sys.argv[1]
p1 = subprocess.Popen(cmd1, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
child = pexpect.spawn("git push -u origin master")
child.expect("Username for 'https://github.com':")
child.sendline("jsonhc")
child.expect("Password for 'https://jsonhc@github.com'")
child.sendline("HHq123456*")
child.expect("Branch master*")

