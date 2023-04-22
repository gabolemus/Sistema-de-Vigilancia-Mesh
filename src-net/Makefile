CC = g++
CPPFLAGS = -Wall -Wextra -pthread
DEBUGFLAGS = -ggdb3
TARGET = main
TARGET_NAME = mesh-net-surveillance

all: ./src/$(TARGET).cpp
	if [ ! -d "../exe" ]; then mkdir ../exe; fi
	$(CC) $(CPPFLAGS) ./src/*.cpp -o ../exe/$(TARGET_NAME)

run:
	../exe/$(TARGET_NAME)

clean:
	rm -f ../exe/$(TARGET_NAME)

dbg:
	$(CC) $(CPPFLAGS) $(DEBUGFLAGS) ./src/*.cpp -o ./debug/$(TARGET_NAME)_debug

debugFile:
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=./debug/$(TARGET_NAME)-out.txt ./debug/$(TARGET_NAME)_debug

cleanDebug:
	rm -f ./debug/$(TARGET_NAME)-out.txt ./debug/$(TARGET_NAME)_debug
