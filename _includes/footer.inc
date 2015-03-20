</div>
<div class="column" id="sidecolumn">
  <div class="header"><a>SideNotes</a></div>
  <div class="sidecol">
	<h1>Recent Posts</h1>
		<ul>
		  {% for post in site.posts limit:5 %}
		  <li><a href="{{ post.url}}">{{ post.title }}</a></li>
		  {% endfor %}
		  <li><a href="/archives.html">Archives</a></li>
		</ul>
  </div>
</div>
<div id="footer">
  <p>Copyright &copy; Jacob Martin, 2015</p>
</div>
</div>
</body>
</html>
																																				  
