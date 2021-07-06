CFLAGS=-I native
LDFLAGS=-L native -llid -ldl -lpthread -Wl,-rpath=native

all: test_lid

test_lid: test_lid.o
	g++ $^ -o $@ $(LDFLAGS)

%.o: %.c
	g++ $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o *.a test_lid
