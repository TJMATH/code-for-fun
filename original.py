import sys
import math
import time

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Bad coding example 1
#
# Original Fortran version shamefully written by Ross Walker (SDSC, 2006)
#
# This code reads a series of coordinates and charges from the file
# specified as argument $1 on the command line.
#
# This file should have the format:
#  I9
# 4F10.4   (repeated I9 times representing x,y,z,q)
#
# It then calculates the following fictional function:
#
#             exp(rij*qi)*exp(rij*qj)   1
#    E = Sum( ----------------------- - - )  (rij <= cut)
#        j<i           r(ij)            a
#
# where cut is a cut off value specified on the command line ($2),
# r(ij) is a function of the coordinates read in for each atom and
# a is a constant.
#
# The code prints out the number of atoms, the cut off, total number of
# atom pairs which were less than or equal to the distance cutoff, the
# value of E, the time take to generate the coordinates and the time
# taken to perform the calculation of E.
#
# All calculations are done in double precision.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

a = 3.2

time0=time.clock()
print ('Value of system clock at start = %14.4f'%time0)

# Step 1 - obtain the filename of the coord file and the value of
# cut from the command line.
#         Argument 1 should be the filename of the coord file (char).
#         Argument 2 should be the cut off (float).
argv=sys.argv
if len(argv) < 3:
   print ("Too few arguments")
else:
   try:
      filename=argv[1]
      print ("Coordinates will be read from file: %s"%filename)
      cut=float(argv[2])
   except(TypeError,ValueError):
      print ("Input error")

# Step 2 - Open the coordinate file and read the first line to
# obtain the number of atoms
fp=open(r'/Users/kunyang/Desktop/Codes for fun/input-10000.txt', 'r')
natom=int(fp.readline().strip())

print ('Natom = %d'% natom)
print ('  cut = %10.3e'% cut)

# Step 3 - Set up the arrays to store the coordinate and charge data
coords=[[0.0 for j in range(3)] for i in range(natom)]
q=[0]*natom

# Step 4 - read the coordinates and charges.
count=0
for line in fp:
    linelist=[]
    coords[count]=[]
    linelist=list(map(float,line.strip().split()))
    coords[count].extend(linelist[0:3])
    q[count]=linelist[3]
    count+=1

time1=time.clock()
print ('Value of system clock after coord read = %14.4f'%time1)

# Step 5 - calculate the number of pairs and E. - this is the
# majority of the work.
total_e = 0.0
cut_count = 0
for i in range(natom):
    for j in range(natom):
        if ( j < i ):   #Avoid double counting.
            vec2 = (coords[i][0]-coords[j][0])**2 + (coords[i][1]-coords[j][1])**2 \
                   + (coords[i][2]-coords[j][2])**2
            #X^2 + Y^2 + Z^2
            rij = math.sqrt(vec2)
            #Check if this is below the cut off
            if ( rij <= cut ):
              #Increment the counter of pairs below cutoff
               cut_count+=1
               current_e = (math.exp(rij*q[i])*math.exp(rij*q[j]))/rij
               total_e = total_e + current_e - 1.0/a

#time after reading of file and calculation
time2=time.clock()
fp.close()
print ('Value of system clock after coord read and E calc = %14.4f'%time2)

# Step 6 - write out the results
print ('                         Final Results')
print ('                         -------------')
print ('                   Num Pairs = %14.4f ' %cut_count)
print ('                     Total E = %14.4f' %total_e)
print ('     Time to read coord file = %14.4f Seconds'% (time1-time0))
print ('         Time to calculate E = %14.4f Seconds'% (time2-time1))
print ('        Total Execution Time = %14.4f Seconds'% (time2-time0))
