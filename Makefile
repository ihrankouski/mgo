include $(GOROOT)/src/Make.inc

TARG=launchpad.net/mgo
GOFMT=gofmt -spaces=true -tabindent=false -tabwidth=4

GOFILES=\
	session.go\
	cluster.go\
	server.go\
	socket.go\
	stats.go\
	queue.go\
	log.go\

all: package

testpackage: _testdb

_testdb:
	@testdb/setup.sh start

startdb:
	@testdb/setup.sh start

stopdb:
	@testdb/setup.sh stop

clean: stopdb

GOFMT=gofmt -spaces=true -tabwidth=4 -tabindent=false
BADFMT:=$(shell $(GOFMT) -l $(GOFILES) $(CGOFILES) $(wildcard *_test.go) 2> /dev/null)

gofmt: $(BADFMT)
	@for F in $(BADFMT); do $(GOFMT) -w $$F && echo $$F; done

ifneq ($(BADFMT),)
ifneq ($(MAKECMDGOALS),gofmt)
$(warning WARNING: make gofmt: $(BADFMT))
endif
endif

include $(GOROOT)/src/Make.pkg

