dist_bin_SCRIPTS = brew \
				   define \
				   free \
				   fstat
CLEANFILES = $(dist_bin_SCRIPTS)
EXTRA_DIST = define.py \
			 free.pl

do_subst = sed -e 's,[@]VERSION[@],$(VERSION),g' \
		   -e 's,[@]PACKAGE[@],$(PACKAGE),g'

brew: brew.rb Makefile
	$(do_subst) < $(srcdir)/$< > $@
	chmod +x $@

define: define.py Makefile
	$(do_subst) < $(srcdir)/$< > $@
	chmod +x $@

free: free.pl Makefile
	$(do_subst) < $(srcdir)/$< > $@
	chmod +x $@

fstat: fstat.pl Makefile
	$(do_subst) < $(srcdir)/$< > $@
	chmod +x $@
