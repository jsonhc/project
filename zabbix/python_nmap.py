# yum install nmap
# wget https://files.pythonhosted.org/packages/
# tar xf python-nmap-0.6.1.tar.gz
# cd python-nmap-0.6.1
# python setup.py install
import nmap
nm = nmap.PortScanner()
nm.scan('172.16.23.128', '123')
print nm['172.16.23.128'].state()
