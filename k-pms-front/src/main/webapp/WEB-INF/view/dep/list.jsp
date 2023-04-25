<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Random"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="context" value="${pageContext.request.contextPath}" />
<c:set var="date" value="<%= new Random().nextInt() %>" />
<c:set scope="request" var="selected" value="dep"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="../include/stylescript.jsp" />
<script type="text/javascript">
	
	var depHd;
	
	function addHdEmpFn(message) {
		
		var depHdIdItems = $("#addDepHeadBtn").closest(".create-group").find(".items");
		if (depHdIdItems.find("." + message.empid	).length > 0) {
			alert(message.lnm + message.fnm + "은(는) 이미 추가된 부서장입니다.");
			return;
		}
		
		var itemDiv = depHdIdItems.find(".head-item");
		
		var itemId = itemDiv.find("#depHdId")
		console.log(message.empid);
		itemId.val(message.empid);
		itemDiv.append(itemId);
		
		var itemSpan = itemDiv.find("span");
		itemSpan.text(message.lnm + message.fnm);
		itemDiv.append(itemSpan);
		
		$("#depHdId").val(message.empid);
		$("#depHdId").attr("class", message.empid);
		console.log(message.lnm + message.fnm);
		$("#depHdNm").text(message.lnm + message.fnm);
		
		depHdIdItems.append(itemDiv);
		
		depHd.close();
	}
	
	$().ready(function() {
		
		$(".grid > table > tbody > tr").click(function() {
			$("#isModify").val("true"); //수정모드
			
			var data = $(this).data();
			$("#depId").val(data.depid);
			$("#depNm").val(data.depnm);
			$("#depHdId").val(data.dephdid);
			$("#depCrtDt").val(data.depcrtdt);
			$("#crtr").val(data.crtr);
			$("#crtDt").val(data.crtdt);
			$("#mdfyr").val(data.mdfyr);
			$("#mdfyDt").val(data.mdfydt);

			
			$("#useYn").prop("checked", data.useyn == "Y");
			
		});
		
			$("#new_btn").click(function() {
			
			$("#isModify").val("false"); //등록모드
			
			$("#depId").val("");
			$("#depNm").val("");
			$("#depHdId").val("");
			$("#depCrtDt").val("");
			$("#crtr").val("");
			$("#crtDt").val("");
			$("#mdfyr").val("");
			$("#mdfyDt").val("");
			
			$("#useYn").prop("checked", false);
		});
		
		$("#delete_btn").click(function() {
			var depId =$("#depId").val()
			if (depId == "") {
				alert("선택된 부서가 없습니다.");
				return;
			}
			
			if (!confirm("정말 삭제하시겠습니까?")) { <!-- 사용자에게 확인  확인시 예를 누르면 false값이 return으로 온다.-->
				return;
			}
			
			$.get("${context}/api/dep/delete/" + depId, function(response) {
				if (response.status == "200 OK") {
					location.reload(); //새로고침
				}
				else {
					alert(response.errorCode + " / " + response.message);
				}
			});
		})
		
		$("#save_btn").click(function() {
			var ajaxUtil = new AjaxUtil();
			if($("#isModify").val() == "false") {
				//신규등록
				ajaxUtil.upload("#detail_form","${context}/api/dep/create",function(response){
					if (response.status == "200 OK") {
						location.reload(); //새로고침
					}
					else {
						alert(response.errorCode + " / " + response.message);
					}
				});
			}
			else {
				//수정
				ajaxUtil.upload("#detail_form","${context}/api/dep/update",function(response){
					if (response.status == "200 OK") {
						location.reload(); //새로고침
					}
					else {
						alert(response.errorCode + " / " + response.message);
					}
				});
			}
		});
		
		$("#search-btn").click(function() {
			movePage(0);
		});
		
		$("#all_check").change(function() {
			
			$(".check_idx").prop("checked", $(this).prop("checked"));
		});
		
		$(".check_idx").change(function() {
			var count = $(".check_idx").length;
			var checkCount = $(".check_idx:checked").length;
			$("#all_check").prop("checked", count == checkCount);
		});
		
		$("#delete_all_btn").click(function() {
			var checkLen = $(".check_idx:checked").length;
			if (checkLen == 0) {
				alert("삭제할 부서가 없습니다.");
				return;
			}
			
			var form = $("<form></form>")
			
			$(".check_idx:checked").each(function() {
				console.log($(this).val());
				form.append("<input type='hidden' name='depId' value='" + $(this).val() + "'>"); 
			});
			
			$.post("${context}/api/dep/delete", form.serialize(), function(response) {
				if (response.status == "200 OK") {
					location.reload(); //새로고침
				}
				else {
					alert(response.errorCode + " / " + response.message);
				}
			});
		});
		
		$("#addDepHeadBtn").click(function(event) {
			event.preventDefault();
			var depId = $("#depId").val();
			depHd = window.open("${context}/emp/search/head?depId=" + depId, "부서장 검색", "width=500,height=500");
		});
		
	});
		 function movePage(pageNo) {
			var searchOption = $("#search-option").val();
			var searchKeyword = $("#search-keyword").val();
			var queryString = "?pageNo=" + pageNo;
			queryString += "&searchOption=" + searchOption;
			queryString += "&searchKeyword=" + searchKeyword;
			
			location.href = "${context}/dep/list" + queryString;
		}
		 
		 
</script>
</head>
<body>
	<div class="main-layout">
		<jsp:include page="../include/header.jsp" />
		<div>
			<jsp:include page="../include/depSidemenu.jsp" />
			<jsp:include page="../include/content.jsp" />
				<div class="path">부서관리 > 부서 목록</div>
			<div class="search-group">
				<label for="search-option">검색 옵션</label> 
				<select id="search-option" class="search-input">
					<option value="depNm" ${depVO.searchOption eq "depNm" ? "selected": ""}>부서명</option>
					<option value="tmNm" ${depVO.searchOption eq "tmNm" ? "selected": ""}>팀명</option>
					<option value="hdLnm" ${depVO.searchOption eq "hdLnm" ? "selected": ""}>부서장 성</option>
					<option value="hdFnm" ${depVO.searchOption eq "hdFnm" ? "selected": ""}>부서장 이름</option>
					<option value="tmLnm" ${depVO.searchOption eq "tmLnm" ? "selected": ""}>팀장 성</option>
					<option value="tmFnm" ${depVO.searchOption eq "tmFnm" ? "selected": ""}>팀장 이름</option>
				</select> 
				<label for="search-keyword">검색어</label> 
				<input type="text" id="search-keyword" class="search-input" />
				<button class="btn-search" id="search-btn">검색</button>
			</div>
				<div class="grid">
					
					<div class="grid-count align-right">
						 총 ${depList.size() > 0 ? depList.get(0).totalCount : 0}건  
					</div>
					<table>
						<thead>
							<tr>
								<th><input type="checkbox" id="all_check" /></th>
								<th>순번</th>
								<th>부서ID</th>
								<th>부서명</th>
								<th>부서장ID</th>
								<th>부서장명</th>
								<th>부서생성일</th>
								<th>사용여부</th>
								<th>등록자</th>
								<th>등록일</th>
								<th>수정자</th>
								<th>수정일</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty depList}">
									<c:forEach items="${depList}"
												var="dep"
												varStatus="index">
										<tr data-depid="${dep.depId}"
											data-depnm="${dep.depNm}"
											data-dephdid="${dep.depHdId}"
											data-depcrtdt="${dep.depCrtDt}"
											data-useyn="${dep.useYn}"
											data-crtr="${dep.crtr}"
											data-crtdt="${dep.crtDt}"
											data-mdfyr="${dep.mdfyr}"
											data-mdfydt="${dep.mdfyDt}">
											<td>
												<input type="checkbox" class="check_idx" value="${dep.depId}"/>
											</td>
											<td>${dep.rnum}</td>
											<td>${dep.depId}</td>
											<td><a href="${context}/dep/detail/${dep.depId}">${dep.depNm}</a></td>
											<td>${dep.depHdId}</td>
											<td>${dep.hdNmEmpVO.lNm}${dep.hdNmEmpVO.fNm}</td>
											<td>${dep.depCrtDt}</td>
											<td>${dep.useYn}</td>
											<td>${dep.crtr}(${dep.crtrEmpVO.lNm}${dep.crtrEmpVO.fNm})</td>
											<td>${dep.crtDt}</td>
											<td>${dep.mdfyr}(${dep.mdfyrEmpVO.lNm}${dep.mdfyrEmpVO.fNm})</td>
											<td>${dep.mdfyDt}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="11" class="no-items">
											등록된 부서가 없습니다.
										</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
					
					<div class="align-right mt-10">
						<button id="delete_all_btn" class="btn-delete">삭제</button>
					</div>
					<c:import url="../include/pagenate.jsp">
                  		<c:param name="pageNo" value="${pageNo}"/>
                  		<c:param name="pageCnt" value="${pageCnt}"/>
                  		<c:param name="lastPage" value="${lastPage}"/>
                  		<c:param name="path" value="${context}/dep"/>
					</c:import>
				</div>
				
				<div class="grid-detail">
					<form id="detail_form">
						<!--
						isModify == true => 수정 (update)
						isModify == false => 등록 (insert)	
						-->
						<input type="hidden" id="isModify" value="false" />
						<div class="input-group inline">
							<label for="depId" style="width: 180px;">부서ID</label><input type="text" id="depId" name="depId" readonly value="" />
						</div>
						<div class="input-group inline">
							<label for="depNm" style="width: 180px;">부서명</label><input type="text" id="depNm" name="depNm" value=""/>
						</div>
						<div class="input-group inline">
							<div class="create-group">
								<label for="addDepHeadBtn" style="width: 180px;">부서장ID</label>
								<button id="addDepHeadBtn" class="btn-p">등록</button>
								<div class="items">
									<div class='head-item'>
										<input type='text' class="" name='depHdId' id="depHdId" readonly value="" />
										<span id="depHdNm"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="input-group inline">
							<label for="depCrtDt" style="width: 180px;">부서생성일</label><input type="date" id="depCrtDt" name="depCrtDt" />
						</div>
						<div class="input-group inline">
							<label for="useYn" style="width: 180px;">사용여부</label><input type="checkbox" id="useYn" name="useYn" value="Y"/>
						</div>
						<div class="input-group inline">
							<label for="crtr" style="width: 180px;">등록자</label><input type="text" id="crtr" disabled value=""/>
						</div>
						<div class="input-group inline">
							<label for="crtDt" style="width: 180px;">등록일</label><input type="text" id="crtDt" disabled value=""/>
						</div>
						<div class="input-group inline">
							<label for="mdfyr" style="width: 180px;">수정자</label><input type="text" id="mdfyr" disabled value=""/>
						</div>
						<div class="input-group inline">
							<label for="mdfyDt" style="width: 180px;">수정일</label><input type="text" id="mdfyDt" disabled value=""/>
						</div>
					</form>
				</div>
				<div class="align-right">
					<button id="new_btn" class="btn-primary">신규</button>
					<button id="save_btn" class="btn-primary">저장</button>
					<button id="delete_btn" class="btn-delete">삭제</button>
				</div>
			<jsp:include page="../include/footer.jsp" />
		</div>
	</div>
</body>
</html>