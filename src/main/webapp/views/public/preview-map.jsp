<%@ page import="Model.Restaurant" %>
<%@ page import="Dao.RestaurantDao" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <% Restaurant restaurant = new RestaurantDao().getById(Long.parseLong(request.getParameter("id"))); %>
    <%= restaurant.getMapEmbedUrl() %>
</body>
</html>
