CFLAGS=-Wall -Wextra -O2 -std=c99
INSTALLDIR=$(HOME)/Applications/libexec
app: ttl

clean: ttl
	/bin/rm ttl

install: ttl
	install -d $(INSTALLDIR)
	install ./ttl $(INSTALLDIR)/

ttl : ttl.c
