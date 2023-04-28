<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="context" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="../include/stylescript.jsp"/>
<script type="text/javascript">
	var file_volume = 0;
	
	$().ready(function() {
		
		$("#delete_btn").click(function() {
			
			$.get("${context}/api/rcvmsg/delete/${rcvMsgVO.msgId}", function(response) {
				if (response.status == "200 OK") {
					location.href = "${context}/rcvmsg/list";
				}
				else {
					alert(response.status == "500");
				}
			});
		});
		$("#file_list").find(".file_name").click(function(e){
			var data = $(this).closest(".file_item").data();
			location.href= "${context}/api/file/download?uuidFlNm="+data.uuid+"&orgFlNm="+data.org;
		});
		$(".file_attachment").find(".save_all").click(function(e){
			e.preventDefault();
			var fileList = $("#file_list").find(".file_item");
			var form = $("<form></form>");
			form.append("<input type='hidden' name='fileNm' value='${rcvMsgVO.sndMsgVO.ttl}'>");
			var idx =0;
			fileList.each(function(){
				var data = $(this).data();
				form.append("<input type='hidden' name='atchFlVOList["+idx+"].uuidFlNm' value='"+ data.uuid +"'>");
				form.append("<input type='hidden' name='atchFlVOList["+idx++ +"].orgFlNm' value='"+ data.org +"'>");
				$("body").append(form);
			});
			form.attr({
				"action": "${context}/api/files/download",
				"method": "post"
			}).submit();
			form.remove();
		});
	})
</script>
</head>
<body>
	<div class="main-layout">
		<jsp:include page="../include/header.jsp"/>
		<div>
			<jsp:include page="../include/msgSidemenu.jsp"/>
			<jsp:include page="../include/content.jsp"/>
			<div class="path"> 받은쪽지함</div>
			<div class="grid">
				<div class="msg_view_header">
					<h4 class="msg_title">${sndMsgVO.ttl}</h4>
					<div>
						<div class="msg_option sndr">
							<strong class="option_title">보낸사람</strong>
							<div class="option_area">${sndMsgVO.sndEmpVO.lNm}${sndMsgVO.sndEmpVO.fNm} &lt;${sndMsgVO.crtr}&gt;</div>
						</div>
						<div class="msg_option rcvr">
							<strong class="option_title">받는사람</strong>
							<div class="option_areas">
								<c:forEach items="${sndMsgVO.rcvMsgVO}" var="rcvMsgVO">
									<div class="option_area">${rcvMsgVO.rcvrEmpVO.lNm}${rcvMsgVO.rcvrEmpVO.fNm} &lt;${rcvMsgVO.rcvr}&gt;</div>
								</c:forEach>
							</div>
						</div>
					</div>
					<div class="info_area">
						<span class="date">${rcvMsgVO.crtDt}</span>
					</div>
				</div>
				<div class="msg_view_body">
					<div class="msg_view_contents">
						<div style="font-size: 14px; font-family: Gulim, 굴림, sans-serif;">
							${sndMsgVO.cntnt}
						</div>
					</div>
					<div class="file_attachment">
						<div class="file_attachment_summary">
							<span class="total_count">첨부 개</span>
							<span class="total_volume">전체용량</span>
							<button class="save_all">모두저장</button>
						</div>
						<div class="file_attachments_inner">
							<ul id="file_list">
								<c:if test="${not empty sndMsgVO.atchFlList and sndMsgVO.atchFlList.get(0).flSz != 0}">
									<c:forEach items="${sndMsgVO.atchFlList}" var="atchFl">
										<li class="file_item"
											data-uuid='${atchFl.uuidFlNm}'
											data-org='${atchFl.orgFlNm}'
											data-sz='${atchFl.flSz}'
											data-ext='${atchFl.flExt}'>
											<span class='file_name mr-10'>${atchFl.orgFlNm}</span>
											<c:if test="${atchFl.flSz < 1024*1024}">
												<span class='file_size'>${String.format("%.2f",atchFl.flSz/1024)} KB</span>
											</c:if>
											<c:if test="${atchFl.flSz >= 1024*1024}">
												<span class='file_size'>${String.format("%.2f",atchFl.flSz/1024/1024)} MB</span>
											</c:if>
										</li>
									</c:forEach>
								</c:if>
							</ul>
						</div>
					</div>
				</div>
				<div class="button_btm-left">
					<button id="delete_btn" class="btn-delete">삭제</button>
				</div>
				<div class="msg_view_footer">
				</div>
			</div>
		</div>
	</div>
</body>
</html>