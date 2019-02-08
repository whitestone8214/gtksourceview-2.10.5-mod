#!/bin/bash

# To build: ./oneshot.sh build
# To install: ./oneshot.sh install [root-directory]
# To link: ./oneshot.sh link [root-directory]
# To unlink: ./oneshot.sh unlink
# To uninstall: ./oneshot.sh uninstall


_versionGSV="2.10.5"
_editionGSV="1"
_destinationGSV="packages/gtksourceview/${_versionGSV}-${_editionGSV}"

if (test "$1" = "build"); then
	./configure --prefix=$2/${_destinationGSV} || exit 1
	gcc $(pkg-config --cflags --libs gtk+-x11-2.0 libxml-2.0) -DHAVE_CONFIG_H -DDATADIR=\"$2/${_destinationGSV}/assets\" -DG_LOG_DOMAIN=\"GtkSourceView\" -I. -Igtksourceview -Igtksourceview/completion-providers/words gtksourceview/completion-providers/words/gtksourcecompletionwords{,library,proposal}.c gtksourceview/gtksource{buffer,iter,view,undomanager,undomanagerdefault,language,languagemanager,language-parser-1,language-parser-2,view-i18n,view-utils,style,styleschememanager,stylescheme,engine,contextengine,mark,printcompositor,gutter,completion,completioninfo,completionitem,completionproposal,completionprovider,completionmodel,completionutils,completioncontext,view-marshal,view-typebuiltins}.c gtksourceview/gtktextregion.c -fPIC -shared -o libgtksourceview.so || exit 1
elif (test "$1" = "install"); then
	$0 uninstall || exit 1
	
	mkdir -p $2/${_destinationGSV}/{includes,assets/{pkgconfig,rules,skins}} || exit 1
	cp -f libgtksourceview.so $2/${_destinationGSV}/ || exit 1
	cp -f gtksourceview/language-specs/*.lang gtksourceview/language-specs/{language.rng,language2.rng,language.dtd,check.sh,convert.py} $2/${_destinationGSV}/assets/rules/ || exit 1
	cp -f gtksourceview/language-specs/*.xml gtksourceview/language-specs/styles.rng $2/${_destinationGSV}/assets/skins/ || exit 1
	cp -f gtksourceview/completion-providers/words/gtksourcecompletionwords.h $2/${_destinationGSV}/includes/completion-providers/words/ || exit 1
	cp -f gtksourceview/gtksource{buffer,iter,view,language,languagemanager,style,styleschememanager,stylescheme,mark,printcompositor,gutter,undomanager,completion,completioninfo,completionitem,completionproposal,completionprovider,completioncontext,view-typebuiltins}.h $2/${_destinationGSV}/includes/ || exit 1
	cp -f gtksourceview.pc $2/${_destinationGSV}/assets/pkgconfig/ || exit 1
elif (test "$1" = "link"); then
	$0 unlink || exit 1
	
	ln -sf $2/${_destinationGSV}/libgtksourceview.so /lib || exit 1
	ln -sf $2/${_destinationGSV}/includes /usr/include/gtksourceview || exit 1
	ln -sf $2/${_destinationGSV}/assets/pkgconfig/gtksourceview.pc /lib/pkgconfig/ || exit 1
elif (test "$1" = "unlink"); then
	rm -f /lib/libgtksourceview.so
	rm -f /usr/include/gtksourceview
	rm -f /lib/pkgconfig/gtksourceview.pc
elif (test "$1" = "uninstall"); then
	rm -rf $2/${_destinationGSV} || exit 1
fi
