<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Random"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="context" value="${pageContext.request.contextPath}"/>
<c:set var="date" value="<%= new Random().nextInt() %>"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>홈페이지</title>
	<jsp:include page="../include/stylescript.jsp"/>
	<script type="text/javascript">
		$().ready(function(){
			$("li.nav-item.sys").addClass("active");
			$("li.nav-item").children("a").mouseover(function(){
				$(this).closest(".nav").find(".nav-item.active").removeClass("active");
				if($(this).attr("class")!="nav-item sys"){
					$("li.nav-item.sys").removeClass("active");
				}
				$(this).closest("li.nav-item").addClass("active");
			});
			$(".nav").mouseleave(function(){
				$(this).find(".active").removeClass("active");
				$("li.nav-item.sys").addClass("active");
			});
			$(".sub-item").mouseenter(function(){
				console.log("!");
				/* $(this).closest("li.nav-item.active").find(".active").removeClass("active"); */
				$(this).addClass("active");
			});
		});
	</script>
</head>
<body>
	<div class="main-layout">
		<jsp:include page="../include/header.jsp"/>
		<div>
			<jsp:include page="../include/sysSidemenu.jsp"/>
			<jsp:include page="../include/content.jsp"/>
				안녕하세요! aaa  ${context} ${date} bbb
			<jsp:include page="../include/footer.jsp"/>
		</div>
	</div>
</body>
</html>