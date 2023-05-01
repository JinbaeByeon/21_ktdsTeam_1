<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Random"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="context" value="${pageContext.request.contextPath}" />
<c:set var="date" value="<%=new Random().nextInt()%>" />
<c:set scope="request" var="selected" value="prj"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 수정</title>
<jsp:include page="../include/stylescript.jsp" />
<script type="text/javascript">
	var tmMbr;
	
	function addTmMbrFn(message) {
		
		var tmMbrItems = $(document).find(".tmMbrAddTbody");
		if (tmMbrItems.find("." + message.tmmbrid).length > 0) {
			tmMbr.alert(message.fnm + message.lnm + "은(는) 이미 추가된 팀원입니다.");
			return;
		}

		var tmMbrTr = $("<tr class='tmMbr-tr'></tr>");
		
		var len = tmMbrItems.find(".tmmbr-item").length;
		var itemId = $("<input type='hidden' name='ptmList[" + len + "].tmMbrId' class='tmmbr-item'/>");
		itemId.val(message.tmmbrid);

		var added = $("<input type='hidden' name='ptmList[" + len + "].added' />");
		added.val("true");

		var td = "<td>" + message.empid + "</td>"
		td += "<td>" + message.tmnm + "</td>"
		td += "<td>" + message.fnm + "</td>"
		td += "<td>" + message.lnm + "</td>"
		td += "<td><select class='pstn " +  message.prjtmmbrid + "' name='ptmList[" + len + "].prjPstn'><option value='DEFAULT'>== 선택 ==</option><option value='PM'>총책임자</option><option value='PL'>부책임자</option><option value='TM'>팀원</option></select></td>"
		
		var rmbtn = $("<button class='del-ptm-btn'><span class='material-symbols-outlined'>delete</span></button>")
		
		rmbtn.click(function() {
			$(this).closest(".tmMbr-tr").remove();
		});
		
		tmMbrItems.append(tmMbrTr);
		tmMbrTr.append(itemId);
		tmMbrTr.append(added);
		tmMbrTr.append(td);
		tmMbrTr.append(rmbtn);
	}
	
	$().ready(function() {
		$.get("${context}/api/cmncd/list/002", function(response) {
			var isSelected
			
			for (var i in response.data) {
				var cdNm = response.data[i].cdNm;
				if ($("#original-prjStts").val() == response.data[i].cdId) {
					isSelected = "selected";
				}
				else {
					isSelected = "";
				}
				var option = $("<option value='" + response.data[i].cdId + "' " + isSelected + "></option>");
				option.append(cdNm);
				$("#prjStts-select").append(option)
			}
		});
		
		
		$("#addTmMbrBtn").click(function(event) {
			event.preventDefault();
			tmMbr = window.open("${context}/tm/allsearch", "팀원 추가", "width=800, height=500, scrollbars = no");
		});
		
		$(".del-ptm-btn").click(function(){
			var tr = $(this).closest("td").closest(".tmMbr-tr");
			
			var index = $(this).data("index");
			var deleted = $("<input type='hidden' name='ptmList[" + index + "].deleted' />");
			deleted.val($(this).data("prjtmmbrid"));
			tr.remove();
			$(".tmMbrAddTbody").append(deleted);
			
		});
		
		$(document).on("focus", ".pstn", function() {
			orgPstn = $(this).val();
		}).on("change", ".pstn", function () {
			var chngPstn = $(this).val();
			var pstnList = $(".pstn");
			if(chngPstn=="PM"){
				var cntPM = 0;
				pstnList.each(function(){
					if($(this).val()=="PM"){
						++cntPM;
					}
				});
				if(cntPM > 1){
					alert("총책임자는 1명만 가능합니다.");
					$(this).val("DEFAULT");
					return;
				}
			}
			if(chngPstn=="PL"){
				var cntPL = 0;
				pstnList.each(function(){
					if($(this).val()=="PL"){
						++cntPL;
					}
				});
				if(cntPL > 2){
					alert("부책임자는 2명만 가능합니다.");
					$(this).val("DEFAULT");
					return;
				}
			}
			
			var tr = $(this).closest("td").closest(".tmMbr-tr");
			var index = $(this).data("index");
			if (orgPstn == chngPstn) {
				tr.children(".mdfy").remove();
			}
			else {
				var modifiedDom = tr.children(".mdfy");
				if (modifiedDom.length == 0) {
					var modified = $("<input type='hidden' class='mdfy' name='ptmList[" + index + "].modified' />")
					modified.val($(this).data("prjtmmbrid"));
					tr.append(modified);	 
				}
			}
			/* console.log(orgPstn, chngPstn) */
		});
		
		$("#modify-btn").click(function() {
			var ajaxUtil = new AjaxUtil();
			ajaxUtil.upload("#create_form", "${context}/api/prj/update", function(response) {
				if (response.status == "200 OK") {
					location.href = "${context}" + response.redirectURL;
				}
				else {
					alert(response.errorCode + "/" + response.message);
				}	
			});
		});
		
		
		$("#delete-btn").click(function() {
			var prjId = $("#prjId").val();
			if(!confirm("정말 삭제하시겠습니까?")) {
				return;
			}
			
			$.get("${context}/api/prj/delete/" + prjId, function(response) {
				if (response.status == "200 OK") {
					location.href = "${context}/prj/list"
				}
				else {
					alert(response.errorCode + "/" + response.message);
				}
			});
		});
	});
</script>
</head>
<body>
	<div class="main-layout">
		<jsp:include page="../include/header.jsp" />
		<div>
			<jsp:include page="../include/prjSidemenu.jsp" />
			<jsp:include page="../include/content.jsp" />
				<div class="path">${prjId} | ${prjVO.prjNm}</div>
				<form id="create_form" enctype="multipart/form-data">
					<table class="detail_table">
		                <input type="hidden" id="prjId" name="prjId" value="${prjVO.prjId}" />
		                <tr>
		                    <th>프로젝트명</th>
		                    <td><input type="text" id="prjNm" name="prjNm" value="${prjVO.prjNm}" /></td>
		                </tr>
		                <tr>
		                    <th>고객사</th>
		                    <td><input type="text" id="cstmr" name="cstmr" value="${prjVO.cstmr}" /></td>
		                </tr>
		                <tr>
		                    <th>시작일</th>
		                    <td><input type="date" id="strtDt" name="strtDt" value="${prjVO.strtDt}" readonly/></td>
		                </tr>
		                <tr>
		                    <th>종료일</th>
		                    <td><input type="date" id="endDt" name="endDt" value="${prjVO.endDt}" readonly/></td>
		                </tr>
		                <tr>
		                    <th>프로젝트 상태</th>
		                    <td>
		                    	<input type="hidden" id="original-prjStts" name="original-prjStts" value="${prjVO.prjStts}"/>
								<select id="prjStts-select" name="prjStts"></select>
							</td>
		                </tr>
		                <tr>
		                    <th>사용여부</th>
		                    <td><input type="checkbox" id="useYn" name="useYn" value="Y" ${prjVO.useYn eq 'Y' ? 'checked' : ''}/></td>
		                </tr>
		                <tr>
		                    <th>팀</th>
		                    <td>
		                	<c:choose>
								<c:when test="${not empty tmList}">
									<c:forEach items="${tmList}" var="tm">
											${tm.getValue()} (${tm.getKey()})<br/>
									</c:forEach>
								</c:when>
								<c:otherwise>
										등록된 팀이 없습니다.
								</c:otherwise>
							</c:choose>
							</td>
		                </tr>
		                <tr>
		                    <th>팀원</th>
		                    <td>
		                    	<div>
									<button id="addTmMbrBtn" class="btn regist">팀원 추가</button>
								</div>
		                        <table class="list_table inner_table">
		                        <thead>
		                            <tr>
		                                <th>직원ID</th>
		                                <th>팀</th>
		                                <th>성</th>
		                                <th>이름</th>
		                                <th>권한</th>
		                                <th></th>
		                            </tr>
		                        </thead>
		                        <tbody class="tmMbrAddTbody">
									<c:forEach items="${prjVO.ptmList}" var="ptm" varStatus="index">
										<tr class="tmMbr-tr">
											<input type="hidden" name="ptmList[${index.index}].tmMbrId" class="tmmbr-item" value="${ptm.prjTmMbrId}">
											<td>${ptm.tmMbrVO.empVO.empId}</td>
											<td>${ptm.tmMbrVO.tmVO.tmNm}</td>
											<td>${ptm.tmMbrVO.empVO.fNm}</td>
											<td>${ptm.tmMbrVO.empVO.lNm}</td>
											<td>
												<select class="pstn ${ptm.prjTmMbrId}" name="ptmList[${index.index}].prjPstn" data-index="${index.index}" data-prjtmmbrid="${ptm.prjTmMbrId}">
													<option value="DEFAULT">==선택==</option>
													<option value="PM" ${ptm.prjPstn eq 'PM' ? 'selected' : ''}>총책임자</option>
													<option value="PL" ${ptm.prjPstn eq 'PL' ? 'selected' : ''}>부책임자</option>
													<option value="TM" ${ptm.prjPstn eq 'TM' ? 'selected' : ''}>팀원</option>
												</select>
											</td>
											<td>
												<button class="del-ptm-btn" data-index="${index.index}" data-prjtmmbrid="${ptm.prjTmMbrId}">
													<span class="material-symbols-outlined">delete</span>
												</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
		                    </table>
		                    </td>
		                </tr>
		            </table>
				</form>
        <div class="buttons">
          <button id="modify-btn" class="btn regist">수정</button>
          <button id="delete-btn" class="btn delete">삭제</button>
        </div>
			<jsp:include page="../include/footer.jsp" />			
		</div>
	</div>
</body>
</html>