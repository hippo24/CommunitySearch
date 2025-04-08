<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
</head>
<body>
    <c:if test="${not empty traitList}">
	  <c:forEach var="trait" items="${traitList}">
	    <div class="trait-box">
	      <h2>${trait.name}</h2>
	      <p>${trait.description}</p>
	      <img 
	        src="https://raw.communitydragon.org/latest/game/assets/ux/traiticons/${trait.image.full}" 
	        alt="${trait.name}" 
	        width="64" height="64"
	      />
	    </div>
	  </c:forEach>
	</c:if>
</body>
</html>