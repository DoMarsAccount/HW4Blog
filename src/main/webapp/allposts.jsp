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
		<title>Donovan and Lauren's Blog</title>
  		<link rel="stylesheet" href="style.css">
  	</head>

  	<body align="center">
		<a name="top"></a>

		<div id="header" align="center">
				<img src="logo.png" alt="longhorn" height=50px width=100px>
			<h1>
				<a href="index.jsp" id="main_title">Donovan and Lauren's HW4 Blog</a>
			</h1>
		</div>

		<h2 align="center" class="post_title">
			All Blog Posts ever
		</h2>

		<%
		String guestbookName = request.getParameter("guestbookName");

		if (guestbookName == null) { guestbookName = "default"; }

		pageContext.setAttribute("guestbookName", guestbookName);

	    UserService userService = UserServiceFactory.getUserService();

	    User user = userService.getCurrentUser();

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
			<hr>
	        <%

        	for (int i = 0; i < greetings.size(); i++) {

	       	 	BlogPost blogpost = greetings.get(i);

	            pageContext.setAttribute("blogpost_title", blogpost.getTitle());

	            pageContext.setAttribute("blogpost_date", blogpost.getDate());

        		pageContext.setAttribute("blogpost_content", blogpost.getContent());

        		if(blogpost.getTitle() == null || blogpost.getTitle().equals("")){

        			%>
        			<h5><b>Untitled</b></h5>
        			<% 

        		} else {
        			%>
        			<h5 class="post_title"><b>${fn:escapeXml(blogpost_title)}</b></h5>
        			<%
        		}
				%>
        		<blockquote>${fn:escapeXml(blogpost_content)}</blockquote>
				<%
        		if (blogpost.getUser() == null) {

                    %>
                    <p><i>Posted: ${fn:escapeXml(blogpost_date)} by: Anonymous</i></p>
                    <%

                } else {

                    pageContext.setAttribute("blogpost_user", blogpost.getUser());
                    %>
                    <p><i>Posted: ${fn:escapeXml(blogpost_date)} by: ${fn:escapeXml(blogpost_user.nickname)}</i></p>
                    <%
                }

                %>

                <br>
                <hr>

            <%
	        }
    	}
		%>
		<a href="#top" class="post_title">Back to top</a>
		<hr>
		<p></p>
		
  	</body>

</html>
