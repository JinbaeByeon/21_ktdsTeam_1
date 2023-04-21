<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="context" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>팀원 조회 및 등록</title>
<jsp:include page="../include/stylescript.jsp" />
<script type="text/javascript">
	
	$().ready(function() {
		$(".dep-tbody tr").click(function() {
			$(".dep-tbody").find("tr").removeClass("active");
			$(this).toggleClass("active");
			var activeDepId = $(".active").data("depid");
			
			$(".tm-tbody").find("tr").remove();
			
			$.get("${context}/api/tm/list/" + activeDepId, function(response) {
				for (var i in response.data) {
					var tmId = response.data[i].tmId;
					var depId = response.data[i].depId;
					var tmNm = response.data[i].tmNm;
					var tmHdId = response.data[i].tmHdId;
					var lNm = response.data[i].tmHdEmpVO.lNm;
					var fNm = response.data[i].tmHdEmpVO.fNm;
					
					var tr = $("<tr data-tmid='" + tmId + "'></tr>");
					var td = "<td>" + tmId + "</td>"
					td += "<td>" + tmNm + "</td>"
					td += "<td>" + tmHdId + "</td>"
					td += "<td>" + lNm + "</td>"
					td += "<td>" + fNm + "</td>"
					
					$(".tm-tbody").append(tr);
					tr.append(td);
				}
			});
		});
		
		$(document).on("click", ".tm-tbody tr", function() {
			$(".tm-tbody").find("tr").removeClass("active");
			$(this).addClass("active");
			console.log($(".tm-tbody .active").data());
			var activeTmId = $(".tm-tbody .active").data("tmid");
			
			$(".tmmbr-tbody").find("tr").remove();

			$.get("${context}/api/tmmbr/list/" + activeTmId, function(response) {
				for (var i in response.data) {
					var tmMbrId = response.data[i].tmMbrId;
					var tmId = response.data[i].tmId;
					var empId = response.data[i].empId;
					var fNm = (response.data[i].empVO.fNm == null) ? "" : response.data[i].empVO.fNm;
					var lNm = (response.data[i].empVO.lNm == null) ? "" : response.data[i].empVO.lNm;
					var tmNm = response.data[i].tmVO.tmNm;
					
					var tr = $("<tr data-tmmbrid='" + tmMbrId + "'data-empid='" + empId + "'data-tmid='" + tmId + "'data-fnm='" + fNm + "'data-lnm='" + lNm + "'data-tmnm='" + tmNm + "'></tr>");
					var td = "<td><input type='checkbox' class='check-idx' value=" + tmMbrId + " /></td>"
					td += "<td>" + empId + "</td>"
					td += "<td>" + fNm + "</td>"
					td += "<td>" + lNm + "</td>"
					
					$(".tmmbr-tbody").append(tr);	
					tr.append(td);
				}
			})

		});
		
		$("#search-btn").click(function() {
			location.href = "${context}/tm/search?tmNm=" + $("#searh-tmNm").val();
		});
		
		$("#all_check").change(function() {
			$(".check-idx").prop("checked", $(this).prop("checked"));
			
		});
		
		$(".check-idx").change(function() {
			var count = $(".check-idx").length;
			var checkCount = $(".check-idx:checked").length;
			$("#all_check").prop("checked", count == checkCount);
		});
		
		$("#cancel-btn").click(function() {
			window.close();
		});
		
		$("#regist-btn").click(function() {
			var checkOne = $(".check-idx:checked");
			
			if (checkOne.length == 0) {
				alert("팀원을 선택하세요");
				return;
			}
			
			checkOne.each(function() {
				var each = $(this).closest("tr").data();
				console.log(each);
				opener.addTmMbrFn(each);
			});
			window.close();
		});
		
	});
		 
</script>
</head>
<body>
	<div class="main-layout">
		<jsp:include page="../include/header.jsp" />
		<div>
			<jsp:include page="../include/depSidemenu.jsp" />
			<jsp:include page="../include/content.jsp" />
				<div class="path">팀원 조회 및 등록</div>
				<div class="grid">
					<div class="grid-count align-right">
						 총 ${depList.size() > 0 ? depList.size() : 0}건  
					</div>
					<table class="scroll-table">
						<thead>
							<tr>
								<th>순번</th>
								<th>부서ID</th>
								<th>부서명</th>
								<th>부서장ID</th>
								<th>부서장명</th>
							</tr>
						</thead>
						<tbody class="dep-tbody">
							<c:choose>
								<c:when test="${not empty depList}">
									<c:forEach items="${depList}"
												var="dep"
												varStatus="index">
										<tr data-depid="${dep.depId}"
											data-depnm="${dep.depNm}">
											<td>${index.index + 1}</td>
											<td>${dep.depId}</td>
											<td>${dep.depNm}</td>
											<td>${dep.depHdId}</td>
											<td>${dep.hdNmEmpVO.lNm}${dep.hdNmEmpVO.fNm}</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
				</div>
				<div class="grid">
					<div class="grid-count align-right">
					 총 ${depVO.tmList.size() > 0 ? depVO.tmList.size() : 0}건
					</div>
						<table class="scroll-table">
							<thead>
								<tr>
									<th>팀ID</th>
									<th>팀명</th>
									<th>팀장ID</th>
									<th>팀장 성</th>
									<th>팀장 이름</th>
								</tr>
							</thead>
						<tbody class="tm-tbody"></tbody>
					</table>
				</div>
				<div class="grid">	
					<div class="grid-count align-right">
						 총 ${depVO.empList.size() > 0 ? depVO.empList.size() : 0}건
					</div>
					<table class="scroll-table">
						<thead>
							<tr>
								<th class="input"><input type="checkbox" id="all_check" /></th>
								<th>직원ID</th>
								<th>성</th>
								<th>이름</th>
							</tr>
						</thead>
						<tbody class="tmmbr-tbody"></tbody>
					</table>
				</div>	
			
		<div class="align-right">
			<button id="regist-btn" class="btn-primary">등록</button>
			<button id="cancel-btn" class="btn-delete">취소</button>
		</div>
						
			<jsp:include page="../include/footer.jsp" />
		</div>
	</div>
</body>
</html>