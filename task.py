# -*- coding: utf-8 -*-
import os
from datetime import datetime as dt

Year, WeekNumber, WeekDay = dt.now().isocalendar()
WeekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
WeekDay = WeekDays[WeekDay%7]

taskFile = open(r'/Users/kunyang/Desktop/ToDoLists/tasks', 'rb')
lines = taskFile.readlines()
Tasks = []
for line in lines:
    Tasks.append(line.strip().split(', '))
taskFile.close()

taskDic = dict(zip(['Month'] + WeekDays, Tasks))

ToDoList = taskDic['Month'] + taskDic[WeekDay]
if WeekDay == "Monday" and "健身" in ToDoList:
    ToDoList.remove("健身")
CFA = sorted([x for x in ToDoList if "CFA" in x])
English = sorted([x for x in ToDoList if ("TPO" in x or "背单词" in x)])
ToDoList = list(set(ToDoList) - set(CFA) - set(English))
Coursera = sorted([x for x in ToDoList if ("Ma" in x or "Ge" in x)])
main = sorted(list(set(ToDoList)-set(Coursera)))
ToDoList = [main, CFA, English, Coursera]

today = dt.today()
deadlineSAS = today.replace(month = 5, day = 28)
deadlineCFA = today.replace(month = 6, day = 3)
deadlineCET6 = today.replace(month = 6, day = 10)
toDeadline = {'SAS': (deadlineSAS - today).days, 'CFA': (deadlineCFA - today).days, 'CET': (deadlineCET6 - today).days}

file_obj = open('/Users/kunyang/Desktop/ToDoLists/ToDoList_%s.md'%dt.now().strftime('%Y-%m-%d'), 'w')
file_obj.write('# 今日任务 \n #### Date: %s %s  \n'%(dt.now().strftime('%Y-%m-%d'), WeekDay))
file_obj.write('### Time remaining until DEADLINE:  \n')
for k,v in toDeadline.items():
    if v > 10:
        file_obj.write('* **%s:   %s days**\n'%(k,v))
    if v > 0 and v < 11:
        file_obj.write('* **%s:   Come on!!! Come on!!! You have no time!!! %s days**\n'%(k,v))

i = 1
for todo in ToDoList:
    if len(todo) > 0:
        file_obj.write("## Priority: %s"%i + '\n')
        for td in todo:
            file_obj.write('-[ ] **' + td + '**  \n')
        i = i + 1
file_obj.close()
