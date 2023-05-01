<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="context" value="${pageContext.request.contextPath}" />
<c:set scope="request" var="selected" value="knw"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="../include/stylescript.jsp" />
<script type="text/javascript">
	$().ready(function() {
		
		$("#new_btn").click(function() {
			location.href = "${context}/knw/create";
		});
		
		
		$("#all_check").change(function() {
			$(".check_idx").prop("checked", $(this).prop("checked"));
		});
		
		$(".check_idx").change(function() {
			var count = $(".check_idx").length;
			var checkCount = $(".check_idx:checked").legnth;
			$("#all_check").prop("checked", count == checkCount);
		});
		
		$("#delete_btn").click(function() {
			var checkLen = $(".check_idx:checked").length;
			if(checkLen == 0) {
				alert("삭제할 지식ID가 없습니다.");
				return;
			}
			
			var form = $("<form></form>");
			
			
			$(".check_idx:checked").each(function() {
				console.log($(this).val());
				
				form.append("<input type='hidden' name='knwId' value='" + $(this).val() + "'>");
			});
			
			$.post("${context}/api/knw/delete", form.serialize(), function(response) {});
			
			location.reload();
		});
		
		$(".check_idx").change(function() {
			var count = $(".check_idx").length;
			var checkCount = $(".check_idx:checked").legnth;
			$("#all_check").prop("checked", count == checkCount);
		});
		
		$("#search-btn").click(function() {
			movePage(0);
		});

			
	});
	
	function movePage(pageNo) {
		var searchOption = $("#search-option").val();
		var searchKeyword = $("#search-keyword").val();
		
		var queryString = "?searchOption=" + searchOption;
		queryString += "&searchKeyword=" + searchKeyword;
		queryString += "&pageNo=" + pageNo;
		location.href = "${context}/comknw/list" + queryString;
	}
</script>
</head>
<body>

	<div class="main-layout">
		<jsp:include page="../include/header.jsp" />
		<div>
			<jsp:include page="../include/prjSidemenu.jsp" />
			<jsp:include page="../include/content.jsp" />
				<div class="path">지식관리 > 지식관리 목록</div>
		      <div class="search_wrapper">
		        <div class="search_box">
		          <select id="search-option">
		           <option value="">전체</option>
			        <option value="제목" ${knwSearchVO.searchOption eq "제목" ? "selected" : ""}>제목</option>
			        <option value="프로젝트명" ${knwSearchVO.searchOption eq "프로젝트명" ? "selected" : ""}>프로젝트명</option>
		          </select>
		          <div class="search_field">
		          	 <input type="text" id="search-keyword" class="input" value="${knwSearchVO.searchKeyword}" placeholder="Search" />
		          </div>
		          <div class="search-icon">
		          	<button class="btn-search" id="search-btn"><span class="material-symbols-outlined">search</span></button>
		          </div>
		        </div>
		      </div>
		      <div class="list_section">
		        <div class="total">총 ${knwList.size() > 0 ? knwList.get(0).totalCount : 0} 건</div>
		        <table class="list_table">
		          <thead>
		            <tr>
		                <th><input type="checkbox" id="all_check"></th>
		                <th>지식관리ID</th>
		                <th>제목</th>
		                <th>사용여부</th>
		            </tr>
		          </thead>
		          <tbody>
		            <c:choose>
		                <c:when test="${not empty knwList}">
		                    <c:forEach items="${knwList}" var="knw">
		                        <tr data-knwid="${knw.knwId}" data-ttl="${knw.ttl}"
		                            data-cntnt="${knw.cntnt}" data-vwcnt="${knw.vwCnt}"
		                            data-prjid="${knw.prjId}" data-crtr="${knw.crtr}"
		                            data-crtdt="${knw.crtDt}" data-mdfyr="${knw.mdfyr}"
		                            data-mdfydt="${knw.mdfyDt}" data-useyn="${knw.useYn}">
		                            <td><input type="checkbox" class="check_idx" value="${knw.knwId}"></td>
		                            <td>${knw.knwId}</td>
		                            <td><a href="${context}/knw/detail/${knw.knwId}">${knw.ttl}</a>
		                            </td>
		                            <td>${knw.useYn}</td>
		                        </tr>
		                    </c:forEach>
		                </c:when>
		                <c:otherwise>
		                    <tr>
		                        <td colspan="12" class="no-items">등록된 지식이 없습니다.</td>
		                    </tr>
		                </c:otherwise>
		            </c:choose>
		          </tbody>
		        </table>
					<c:import url="../include/pagenate.jsp">
					    <c:param name="pageNo" value="${pageNo}" />
					    <c:param name="pageCnt" value="${pageCnt}" />
					    <c:param name="lastPage" value="${lastPage}" />
					    <c:param name="path" value="${context}/knw" />
					</c:import>
		        <div class="buttons">
		          <button id="new_btn" class="btn new">신규등록</button>
		          <button id="delete_btn" class="btn delete">선택삭제</button>
		        </div>
		      </div>
			<jsp:include page="../include/footer.jsp" />
		</div>
	</div>
</body>
</html>