function footDiv(n)
{
	return $('<div id="footdiv' + n + '" class="footdiv"><p><a style="float: left;" href="#note' + n +
			 '">Go to footnote on page</a><a style="float: right;" href="#" id="closediv' + n +
			 '">[x]</a></p><p style="clear: both;"></p><p>' + $("#note" + n).text() + '</p></div>');
}

function putFootDiv(n)
{
	footDiv(n).insertAfter($("#ref" + n));
	$("#closediv" + n).click(function (event) { event.preventDefault(); rmFootDiv(n);});
}

function rmFootDiv(n)
{
	$('#footdiv' + n).remove();
}

$(document).ready(function () {
	for (var i = 1; document.getElementById("ref" + i); i++) {
		$("#ref" + i).click((function (n) { return function (event) { event.preventDefault(); putFootDiv(n); };})(i));
	}
});
