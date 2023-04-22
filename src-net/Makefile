CC = g++
CPPFLAGS = -Wall -Wextra -pthread
DEBUGFLAGS = -ggdb3
TARGET = main
TARGET_NAME = mesh-net-surveillance

all: ./src/$(TARGET).cpp
	if [ ! -d "./build" ]; then mkdir ./build; fi
	$(CC) $(CPPFLAGS) ./src/*.cpp -o ./build/$(TARGET_NAME)

run:
	./build/$(TARGET_NAME)

clean:
	rm -f ./build/$(TARGET_NAME)

dbg:
	$(CC) $(CPPFLAGS) $(DEBUGFLAGS) ./src/*.cpp -o ./debug/$(TARGET_NAME)_debug

debugFile:
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=./debug/$(TARGET_NAME)-out.txt ./debug/$(TARGET_NAME)_debug

cleanDebug:
	rm -f ./debug/$(TARGET_NAME)-out.txt ./debug/$(TARGET_NAME)_debug
