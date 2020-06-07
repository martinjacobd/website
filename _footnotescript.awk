#!/usr/bin/gawk -f
BEGIN {
	n = 0;
}

{
	while (match($0, /\|[^\|]*\|/)) {
		n++;

		command = "pandoc -f markdown -t html";
		print substr($0, RSTART+1, RLENGTH-2) |& command;
		close(command, "to");
		note[n] = "";
		while ((command |& getline line) > 0) {
			note[n] = note[n] line;
		}
		close(command);

		gsub(/<p>/, "", note[n]);
		gsub(/<\/p>/, "", note[n]);

		title = note[n];
		gsub(/"/, "", title);
		gsub(/<[^>]*>/, "", title);
		if (length(title) > 350) {
			title = substr(title, 1, 347) "...";
		}
		gsub(/&/, "\\\\&", title);

		gsub(/\|[^\|]*\|/,
			"<a class=\"footref\" id=\"ref" n "\" href=\"#note" n "\" title=\"" title "\">" n "</a>",
			$0);
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
