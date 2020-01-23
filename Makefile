SOURCEFILES=main.vala strategy_app.vala strategy_window.vala strategy_graph.vala
RESOURCEDIR=resources/
RESOURCES=$(RESOURCEDIR).gresource.xml $(RESOURCEDIR)main_window.ui

VALAFLAGS=--pkg gtk+-3.0 --pkg cairo

build : $(SOURCEFILES)
	valac -o strategy_app $(SOURCEFILES) $(VALAFLAGS)

resource : $(RESOURCES)
	glib-compile-resources $(RESOURCEDIR).gresource.xml --target strategy_resources --sourcedir $(RESOURCEDIR)	

.PHONY : c
c : $(SOURCEFILES)
	valac $(VALAFLAGS) $(SOURCEFILES) -C

.PHONY : clean
clean :
	rm -f strategy_app strategy_resources
