<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="guestbook.BlogPost" %>

<%@ page import="com.googlecode.objectify.*" %>





<html>

	<head>
  		<title>HW4 Blog</title>
  	  	<link rel="stylesheet" href="style.css">
  	</head>

  	<body>
  		<div id="title_tab" align="center">
  			<img src="logo.png" alt="globe" height=42px width=42px align="center">
			<h1>
				<a href="index.jsp" id="main_title">Donovan and Lauren's HW4 Blog</a>
			</h1>
	  	</div>
	
		<div class="grid-container">
		
			<div id="item1">
			<!-- SIDE MENU -->
			
			<a href="allposts.jsp"><button class="button">See All Posts</button></a>
<%

	String guestbookName = request.getParameter("guestbookName");

	if (guestbookName == null) {

	    guestbookName = "default";

	}

	pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();
    
    
	// User can post if they've logged in
    if (user != null) {

      pageContext.setAttribute("user", user);

%>
  				<a href="createblogpost.jsp"><button class="button">Create Blog Post</button></a>

				<p>Signed in as: ${fn:escapeXml(user.nickname)}</p>
				
				<form action="/subEmail" method="post">
					      <div><input type="submit" name="Subscribe" value="Subscribe to our posts" class="button"/></div>
					      <input type="hidden" name="subOrUnsub" value="sub"/>
				 </form>
				 <form action="/subEmail" method="post">
					      <div><input type="submit" name="Unsubscribe" value="Unsubscribe from our posts" class="button"/></div>
					      <input type="hidden" name="subOrUnsub" value="unsub"/>
				 </form>
				 
				<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>

<%

    } else {
	// Otherwise...they should login
%>
				<p>To post, please <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">log in</a>.</p>

<%
    }

%>
		
	</div>
	<div id="item2">
	<!-- RECENT POSTS -->
	
	
	<h2 class="post_title" style="text-decoration: underline">Recent posts</h2>
	<hr>
	<div class="scrollable_main">
		<%

    // Run an ancestor query to ensure we see the most up-to-date

    // view of the Greetings belonging to the selected Guestbook.

   	ObjectifyService.register(BlogPost.class);

	List<BlogPost> greetings = ObjectifyService.ofy().load().type(BlogPost.class).list();

	Collections.sort(greetings);
	Collections.reverse(greetings);

    if (greetings.isEmpty()) {

        %>

        <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>

        <%

    } else {

        %>

        <p>BlogPosts in Page '${fn:escapeXml(guestbookName)}'.</p>

        <%

        if(greetings.size() > 0){

	        for (int i = 0; i < 4 && i < greetings.size(); i++) {

        		BlogPost blogpost = greetings.get(i);

	            pageContext.setAttribute("blogpost_title", blogpost.getTitle());

	            pageContext.setAttribute("blogpost_date", blogpost.getDate());

        		pageContext.setAttribute("blogpost_content", blogpost.getContent());
       	%>
        		<%
        		if(blogpost.getTitle() == null || blogpost.getTitle().equals("")){

        		%>
        			<h5 class="post_title"><b>Untitled</b></h5>

        		<% }else{
        		%>
        			<h5 class="post_title"><b>${fn:escapeXml(blogpost_title)}</b></h5>

        		<%
        		}


	            if (blogpost.getUser() == null) {

	                %>

	                <p><i>By: Anonymous</i></p>

	                <%

	            } else {

	                pageContext.setAttribute("blogpost_user", blogpost.getUser());

	                %>

	                <p><i>By: ${fn:escapeXml(blogpost_user.nickname)}</i></p>

	                <%

	            }

	            %>

	           	<p><i>Posted: ${fn:escapeXml(blogpost_date)}</i></p>

	            <blockquote>${fn:escapeXml(blogpost_content)}</blockquote>
	            <br>
	            <hr>


	            <%

	        }
        }
    }

%>
			</div>
			</div>
		
		</div>
	  
	  <br>

  </body>

</html>
