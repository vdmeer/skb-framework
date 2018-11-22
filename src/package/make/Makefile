prefix = /opt/skb/skb-framework


all:
	

install:
	install -d $(DESTDIR)$(prefix)/

	cp -dfrp bin $(DESTDIR)$(prefix)/
	cp -dfrp doc $(DESTDIR)$(prefix)/
	cp -dfrp etc $(DESTDIR)$(prefix)/
	cp -dfrp lib $(DESTDIR)$(prefix)/
	cp -dfrp man $(DESTDIR)$(prefix)/
	cp -dfrp scenarios $(DESTDIR)$(prefix)/

clean:
	-rm -fr $(DESTDIR)$(prefix)/

distclean: clean

uninstall:
	-rm -f $(DESTDIR)$(prefix)/

.PHONY: all install clean distclean uninstall
