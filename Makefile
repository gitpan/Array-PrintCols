# Makefile for Array::PrintCols module
#
#    Copyright (C) 1995  Alan K. Stebbens <aks@hub.ucsb.edu>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#    $Id: Makefile,v 1.7 1995/12/18 23:47:40 aks Exp $

# Set DEFAULT one or more of install-local, install-net, or install-home
#
# If INSTALL_VER is 'yes', this Makefile installs files both with and
# without versions.  The non-version named is linked to the versioned
# name.  This allows updates of a newer version without completely
# stepping on the older version.  Users preferring the older version
# can do:
#
#	use 'Array::PrintCols-1.1';
#
# If INSTALL_VER is 'no', then only the non-version names are installed.
# If INSTALL_MANVER is 'no', then no versions are used on the man pages.
#
#
# Versioned names:
#
#	/usr/local/perl5/lib/Array/PrintCols-1.1.pm
#	/usr/local/perl5/man/man3/Array::PrintCols-1.1.3p
#
# Non-versioned names:
#
#	/usr/local/perl5/lib/Array/PrintCols.pm
#	/usr/local/perl5/man/man3/Array::PrintCols.3p
#

    MOD_NAME = PrintCols
 
       CLASS = Array

# Set this to 'no', if you do not want version numbers to be installed

    INSTALL_VER = yes
 INSTALL_MANVER = no

      MODULE = $(LIB)/$(CLASS)/$(MOD_NAME).pm
  MODULE_VER = $(LIB)/$(CLASS)/$(MOD_NAME)-$(VERSION).pm
     VERSION = 0

# Where Perl 5 lives
        PERL = /usr/local/bin/perl5

     DEFAULT = install-local
 
     NETROOT = /eci/perl5
      NETLIB = $(NETROOT)/lib
      NETMAN = $(NETROOT)/man/man$(MANSEC)
  
   LOCALROOT = /usr/local/perl5
    LOCALLIB = $(LOCALROOT)/lib
    LOCALMAN = $(LOCALROOT)/man/man$(MANSEC)
  
    HOMEROOT = $(HOME)
     HOMELIB = $(HOMEROOT)/lib/perl
     HOMEMAN = $(HOME)/man/man$(MANSEC)
  
      MANSEC = 3
      MANSFX = p
     MANPAGE = $(MAN)/$(CLASS)::$(MOD_NAME).$(MANSEC)$(MANSFX)
 MANPAGE_VER = $(MAN)/$(CLASS)::$(MOD_NAME)-$(VERSION).$(MANSEC)$(MANSFX)

   SHARFILES = README PrintCols.pm Makefile test.pl test.out.ref Copyright GNU-LICENSE
    SHAROPTS = -cCms
     ARCHIVE = $(CLASS)-$(MOD_NAME)-$(VERSION)

     FTPHOST = root@hub.ucsb.edu
     FTPHOME = /usr/home/ftp
  FTPDESTDIR = /pub/prog/perl

# Used for CPAN uploading
 CPANFTPSITE = franz.ww.tu-berlin.de
#CPANFTPSITE = ftp.cis.ufl.edu
  CPANFTPDIR = /incoming
 CPANFTPUSER = ftp
 CPANFTPPASS = aks@hub.ucsb.edu
     

     POD2MAN = pod2man

         LIB = .phony-lib
         MAN = .phony-man

       SHELL = /bin/sh

help:
	@echo 'make install             Default install ($(DEFAULT))'
	@echo 'make install-net         Install in $(NETLIB)'
	@echo 'make install-ftp         Install in $(FTPHOST):$(FTPHOME)$(FTPDESTDIR)'
	@echo 'make install-home        Install in $(HOMELIB)'
	@echo 'make install-local       Install in $(LOCALLIB)'
	@echo 'make install-cpan	Install in CPAN archives'
	@echo 'make uninstall           remove all installed files'
	@echo 'make uninstall-net       remove installed files from $(NETLIB)'
	@echo 'make uninstall-home      remove installed files from $(HOMELIB)'
	@echo 'make uninstall-local     remove installed files from $(LOCALLIB)'
	@echo 'make tar                 Make a tar.gz archive'
	@echo 'make shar                Make a shar archive'
	@echo 'make test                Run canned tests'
	@echo 'make help                This message'

test:	test.out.ref test.out
	-diff test.out.ref test.out > test.out.diff
	@if [ -s test.out.diff ]; then			\
	    echo "There are differences." ; 		\
	else						\
	    echo "No differences." ;			\
	    rm -f test.out.diff test.out ;		\
	fi

test.out.ref:	test.pl
	-$(PERL) test.pl > $@ 2>&1

test.out:	test.pl
	-$(PERL) test.pl > $@ 2>&1

install:	$(DEFAULT)

install-all:	install-local install-home install-net

install-local:
	@$(MAKE) LIB='$(LOCALLIB)' 		\
		MAN='$(LOCALMAN)' 		\
		INSTALL_VER=$(INSTALL_VER) 	\
	    install-version

install-net:	
	@$(MAKE) LIB='$(NETLIB)'		\
		MAN='$(NETMAN)'			\
		INSTALL_VER=$(INSTALL_VER) 	\
	    install-version

install-home:
	@$(MAKE) LIB='$(HOMELIB)' 		\
		MAN='$(HOMEMAN)' 		\
		INSTALL_VER=$(INSTALL_VER) 	\
	    install-version

install-version:
	@if [ "$(INSTALL_VER)" != yes ]; then		\
	    $(MAKE)	MODULE_VER='$(MODULE)' 		\
			LIB='$(LIB)'			\
		install-module ;			\
	else						\
	    $(MAKE) version ;				\
	    $(MAKE) 	LIB='$(LIB)'			\
			VERSION=`cat .version`		\
		install-module ;			\
	fi
	@if [ "$(INSTALL_MANVER)" != yes ]; then	\
	    $(MAKE)	MANPAGE_VER='$(MANPAGE)'	\
			MAN='$(MAN)'			\
		install-man ;				\
	else						\
	    $(MAKE) version ;				\
	    $(MAKE)	MAN='$(MAN)'			\
			VERSION=`cat .version`		\
		install-man ;				\
	fi

install-module:	$(LIB)/$(CLASS) $(MODULE_VER)

$(MODULE_VER):	$(MOD_NAME).pm
	@rm -f $@
	cp $(MOD_NAME).pm $@
	@if [ "$(MODULE_VER)" != "$(MODULE)" ]; then	\
	    $(MAKE) SRC='$(MODULE_VER)' 		\
	    	    LINK='$(MODULE)' 			\
		link ;					\
	fi

link:
	@rm -f $(LINK)
	ln $(SRC) $(LINK)

version:	.version
.version:	$(MOD_NAME).pm
	@rm -f $@
	awk '/[$$]Id[:]/{print $$4}' $(MOD_NAME).pm > $@

install-man:
	@rm -f $(MANPAGE_VER)
	$(POD2MAN) $(MOD_NAME).pm > $(MANPAGE_VER)
	@if [ "$(INSTALL_MANVER)" = yes ] &&		\
	    [ "$(MANPAGE_VER)" != "$(MANPAGE)" ]; then	\
	    $(MAKE) SRC='$(MANPAGE_VER)' 		\
	    	    LINK='$(MANPAGE)' 			\
		link ;					\
	fi

$(LIB) $(LIB)/$(CLASS) $(MAN):
	mkdir -p $@

INSTALLED_FILES = $(MODULE_VER) $(MODULE) $(MANPAGE_VER) $(MANPAGE) 

uninstall:	uninstall-net uninstall-home uninstall-local

uninstall-net:
	@$(MAKE) LIB=$(NETLIB) MAN=$(NETMAN) uninstall-it
uninstall-home:
	@$(MAKE) LIB=$(HOMELIB) MAN=$(HOMEMAN) uninstall-it
uninstall-local:
	@$(MAKE) LIB=$(LOCALLIB) MAN=$(LOCALMAN) uninstall-it

uninstall-it:
	@for file in $(INSTALLED_FILES) ; do	\
	  if [ -f $$file ]; then		\
	    $(MAKE) FILE=$$file remove-it ;	\
	  fi ;					\
	done

remove-it:
	rm -f $(FILE)

# 	Archive creation stuff
#
#  MAKE_ARCHIVE invokes another 'make' at the directory level above the
#  current one, with the variables FILES, DIR, and ARCHIVE set
#  appropriately.

MAKE_ARCHIVE = 	cwd=`pwd` ;			\
		cd .. ; 			\
		dir=`basename $$cwd` ;		\
		files=`echo "$(SHARFILES)" |	\
		       tr ' ' '\12' |		\
		       sed -e "s=^=$$dir/=" |	\
		       tr '\12' ' ' ` ;		\
		$(MAKE) -f $$dir/Makefile	\
			FILES="$$files"		\
			DIR=$$dir		\
			ARCHIVE=$(ARCHIVE)

tar:			version
	@$(MAKE) VERSION="`cat .version`" tar-version

shar:			version
	@$(MAKE) VERSION="`cat .version`" shar-version

shar-version: 		$(ARCHIVE).shar
tar-version: 		$(ARCHIVE).tar.gz

$(ARCHIVE).tar.gz:	$(SHARFILES)
	@$(MAKE_ARCHIVE) make-tar
	@rm -f $@
	gzip $(ARCHIVE).tar

$(ARCHIVE).shar:	$(SHARFILES)
	@$(MAKE_ARCHIVE) make-shar

clean:
	rm -f *.tar.gz *.shar .version

make-tar:	$(FILES)
	@rm -f $(DIR)/$(ARCHIVE).tar
	tar cvf $(DIR)/$(ARCHIVE).tar $(FILES)

make-shar:	$(FILES)
	@rm -f $(DIR)/$(ARCHIVE).shar
	shar $(SHAROPTS) $(FILES) > $(DIR)/$(ARCHIVE).shar

install-ftp: shar tar
	$(MAKE) VERSION=`cat .version` install-ftp-version

install-ftp-version: $(ARCHIVE).shar $(ARCHIVE).tar.gz
	rcp $(ARCHIVE).shar $(ARCHIVE).tar.gz $(FTPHOST):$(FTPHOME)$(FTPDESTDIR)

install-cpan:	shar tar
	$(MAKE) VERSION=`cat .version`		\
		CPANFTPSITE='$(CPANFTPSITE)'	\
		CPANFTPDIR='$(CPANFTPDIR)' 	\
		CPANFTPUSER='$(CPANFTPUSER)'	\
		CPANFTPPASS='$(CPANFTPPASS)'	\
	    install-cpan-version

install-cpan-version: $(ARCHIVE).shar $(ARCHIVE).tar.gz
	@tmp="/tmp/putftp.$$$$"				; \
	( echo '#!/bin/sh' 				; \
	  echo 'ftp -v -n -i <<EOF' 			; \
	  echo 'open $(CPANFTPSITE)'			; \
	  echo 'user $(CPANFTPUSER) $(CPANFTPPASS)'	; \
	  echo 'cd $(CPANFTPDIR)'			; \
	  echo 'binary'					; \
	  echo 'put $(ARCHIVE).tar.gz'			; \
	  echo 'put $(ARCHIVE).shar'			; \
	  echo 'quit'					; \
	  echo 'EOF'					; \
	  echo "rm -f $$tmp"				; \
	) >$$tmp					; \
	sh -x $$tmp
