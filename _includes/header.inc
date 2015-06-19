<!DOCTYPE html>	
<html>	  
  <head>  
    <title>{% if page.title %} {{ page.title }} | {% endif %} JacobMartin.org</title>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="/css/main.css">
	<link rel="stylesheet" type="text/css" href="/css/small.css"
		  media="only screen and (max-width: 480px),
				 only screen and (max-device-width: 480px),
				 only screen and (min-device-width: 560px) and (max-device-width: 1136px) and (-webkit-min-device-pixel-ratio: 2)">
	<link rel="stylesheet" type="text/css" href="/css/screen.css"
		  media="only screen and (min-width: 481px)">
	<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
	<link rel="icon" type="image/x-icon" href="/favicon.ico" />
	{% if page.math %}<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>{% endif %}
	{% if page.footnotes %}
	<script type="text/javascript" src="/scripts/jquery.js"></script>
	<script type="text/javascript" src="/scripts/footnotes.js"></script>
	{% endif %}
  </head>
  <body>
	<header>
	  <h1 id="logo"><a href="/"><img src="/images/logo.png" alt="JacobMartin.org" width="320"></a></h1>
	  <nav id="topnav">
		<ul>
		  <li><a href="/">Home</a></li>
		  <li><a href="/about.html">About</a></li>
		  <li><a href="/copyright.html">Legal</a></li>
		</ul>
	  </nav>
	  <div style="clear: both;"></div>
	</header>
	<div id="lowerpage">
	  <section id="content">
