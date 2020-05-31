#!/usr/bin/awk -f
BEGIN {
	n = 0;
}

{
	while (match($0, /\{[^\}]*\}/)) {
		n++;
		note[n] = substr($0, RSTART+1, RLENGTH-2);
		if (RLENGTH < 350) {
			title = note[n];
		} else {
			title = substr(note[n], 1, 340) "...";
		}
		gsub(/<[^>]*>/, "", title);
		sub(/\{[^}]*\}/, "<a class=\"footref\" id=\"ref" n "\" href=\"#note" n "\" title=\"" title "\">" n "</a>");
	}
	print $0;
}

END {
	if (n > 0) {
		print "<hr />";
		print "<ul class=\"footnotes\" id=\"footnotes\">";
		for (i = 1; i <= n; i++) {
			print "<li id=\"note" i "\"><a href=\"#ref" i "\">" i ".</a> " note[i] "</li>";
		}
		print "</ul>"
	}
}
