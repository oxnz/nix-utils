dist_bin_SCRIPTS = define free
CLEANFILES = $(dist_bin_SCRIPTS)
EXTRA_DIST = define.py \
			 free.pl

do_subst = sed -e 's,[@]VERSION[@],$(VERSION),g' \
		   -e 's,[@]PACKAGE[@],$(PACKAGE),g'

define: define.py Makefile
	$(do_subst) < $(srcdir)/define.py > $@
	chmod +x $@

free: free.pl Makefile
	$(do_subst) < $(srcdir)/free.pl > $@
	chmod +x $@
