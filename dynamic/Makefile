#include $(HCLIB_ROOT)/include/hclib.mak

CXX = g++ 

CXXFLAGS =  -Wall -O2 -g -std=gnu++0x -DALIAS 
#-I/root/hclib_install/include
#CXXFLAGS = -Wall -O2  -std=gnu++0x -I/root/hclib_install/include
LDFLAGS = -pthread


OBJS = CFLReach.o CFLGraph.o

all:  dyckcfl


dyckcfl: CFLGraph.o DyckReach.o FastDLL.o 
	$(CXX) $(CXXFLAGS) $(LDFLAGS) CFLGraph.o DyckReach.o FastDLL.o  -o DyckReach
%.o: %.cpp %.h
	$(CXX) $(CXXFLAGS) -c  $< -o $@
clean:
	rm *.o
	rm DyckReach
