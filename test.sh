#! /bin/bash
echo abc
SUM=0
for i in $(ls);do
  let SUM+=1
done
echo $SUM
