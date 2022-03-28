# test status
# melvin.alvarado

import re


HEADER = '\033[95m'
OKBLUE = '\033[94m'
OKCYAN = '\033[96m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
ENDC = '\033[0m'
BOLD = '\033[1m'
UNDERLINE = '\033[4m'

log = 'xsim.log'

FH = open(log,'r')

status = 'FAIL'
ruleFinish = False

ruleError = False
ruleFatal = False


for l in FH.readlines():
    mFinish = re.search('\$finish called',l)
    mError = re.search('error',l, re.IGNORECASE)
    mFatal = re.search('fatal',l, re.IGNORECASE)
    mZero = re.search('UVM_[A-Z]+ :\s+0$',l)
    if mFinish:
        ruleFinish = True
    if mError and not mZero:
        print(l.rstrip())
        ruleError = True
    if mFatal and not mZero:
        print(l.rstrip())
        ruleFatal = True


if ruleFinish and not ruleFatal and not ruleError:
    status = 'PASS'

FS = open('test.status','w')
if status == 'PASS':
    print('Test: ' + OKGREEN + 'PASS' + ENDC)
else:
    print('Test: ' + FAIL + 'FAIL' + ENDC)

FS.write("Test: "+status+"\n")

FS.close()
FH.close()
