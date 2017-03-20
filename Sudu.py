import numpy as np

def getSudu():
    L = []
    file_obj = open(r'./question.txt', 'r')
    lines = file_obj.readlines()
    for line in lines:
        #print list(line)
        L.append(map(int, list(str(line.strip()))))
    file_obj.close()
    return np.array(L)


def getCandidateSet(Arr, r, c):
    if Arr[r, c] > 0:
        return False
    MySet = set(Arr[r,]) | set(Arr[:, c])
    i = r//3
    j = c//3
    for x in range(3*i, 3*(i+1)):
        MySet = MySet | set(Arr[x,][[3*j,3*j+1,3*j+2]])
    return set([1,2,3,4,5,6,7,8,9]) - MySet


def getAnswer1(Sudu):
    flag = False
    L = range(9)
    for i in range(9):
        L[i] = []
        for j in range(9):
            L[i].append(getCandidateSet(Sudu, i, j))
            if L[i][j] and len(L[i][j]) == 1:
                Sudu[i, j] = list(L[i][j])[0]
                L[i][j] = False
                flag = True
    return [Sudu, flag, L]


def getAnswer2(Sudu, Answers = []):
    flag = True
    while flag:
        Sudu, flag, L = getAnswer1(Sudu)
    if Sudu.all():
        Answers.append(Sudu)
        return [Answers, True]
    elif any([set([]) in x for x in L]):
        return [Answers, True]
    else:
        i = j = 0
        while not L[i][j]:
            j += 1
            if j == 9:
                i = i+1
                j = 0
            if i == 9 and j == 9:
                break
        for x in L[i][j]:
            Sudu2 = Sudu.copy()
            Sudu[i][j] = x
            Answers = getAnswer2(Sudu, Answers)[0]
            Sudu = Sudu2.copy()
        return [Answers, True]


Sudu = getSudu()
print Sudu
print '#########################################################################'
Answers = getAnswer2(Sudu)[0]
i = 1
for answer in Answers:

    print "-----------------No.%s"%i + " answer--------------------------------"
    print answer
    print "rowSum: %s"%sum(answer)
    print "colSum: %s"%sum(answer.T)
    i = i + 1
