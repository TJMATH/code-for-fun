

def __MyIndex__(L, MyTarget):
    '''
    :type L: List[int]
    L should be sorted
    '''
    i = 0
    j = len(L)-1
    flag = False
    while 1:
        if i >= j and L[i] != MyTarget :
            return (False, -1)
        mid = (i+j)/2
        if L[i] == MyTarget :
            return (True, i)
        elif L[mid] >= MyTarget :
            j = mid
        else:
            i = mid+1

def twoSum(numbers, target):
    """
    :type numbers: List[int]
    :type target: int
    :rtype: List[int]
    """
    numbersSet = set(numbers)
    for x in numbersSet:
        if (target - x) in numbersSet:
            _, start = __MyIndex__(numbers, min(x, target - x))
            _, end = __MyIndex__(numbers[start+1:], max(x, target - x))
            return [start + 1, end + start + 2]

'''
def twoSum(numbers, target):
    """
    :type numbers: List[int]
    :type target: int
    :rtype: List[int]
    """

    l = len(numbers)
    ban = target - numbers[-1]
    for i in xrange(l):
        if numbers[i] < ban:
            continue
        flag, MyIndex = self.__MyIndex__(numbers[i+1:], target - numbers[i])
        if flag:
            return [i + 1, i + 2 + MyIndex]
        else:
            continue

    numbersSet = set(numbers)
    for x in numbersSet:
        if (target - x) in numbersSet:
            start = numbers.index(min(x, target -x)) + 1
            end = numbers[start:].index(max(x, target - x)) + start + 1
            return [start, end]
'''
print twoSum([2,3,4], 6)
