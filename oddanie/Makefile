CC = gcc 
CFLAGS = -Wall -m64 -no-pie

all: main.o func.o
	$(CC) $(CFLAGS) -o arko_histogram_kontrast main.o func.o `sdl2-config --cflags --libs`

func.o: func.s
	gcc -m64 -c func.s

main.o: main.c func.h
	$(CC) $(CFLAGS) -c -o main.o main.c

clean:
	rm -f *.o


