<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>类型变更记录</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
  	<form name="form1" method="post" id="form1" class="l-form">
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>类型变更记录</span>
		</div>
			<div class="tableDiv clearfix">
				<table class="table-product" id="dptable">
					<thead>
						<tr>
							<th>序号</th>
							<th>会员</th>
							<th>变更前</th>
							<th>变更后</th>
							<th>变更时间</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${records }" var="record" varStatus="status">
							<tr>
								<td>${status.index+1 }</td>
								<td>${member.nickname }</td>
								<td>
									<c:choose>
										<c:when test="${record.beforetype=='R' }">注册顾客</c:when>
										<c:when test="${record.beforetype=='N' }">新顾客</c:when>
										<c:when test="${record.beforetype=='E' }">活跃顾客</c:when>
										<c:when test="${record.beforetype=='S1' }">瞌睡顾客</c:when>
										<c:when test="${record.beforetype=='S2' }">半睡顾客</c:when>
										<c:when test="${record.beforetype=='S3' }">沉睡顾客</c:when>
										<c:when test="${record.beforetype=='X1' }">唤醒瞌睡</c:when>
										<c:when test="${record.beforetype=='X2' }">唤醒半睡</c:when>
										<c:when test="${record.beforetype=='X3' }">唤醒沉睡</c:when>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${record.aftertype=='R' }">注册顾客</c:when>
										<c:when test="${record.aftertype=='N' }">新顾客</c:when>
										<c:when test="${record.aftertype=='E' }">活跃顾客</c:when>
										<c:when test="${record.aftertype=='S1' }">瞌睡顾客</c:when>
										<c:when test="${record.aftertype=='S2' }">半睡顾客</c:when>
										<c:when test="${record.aftertype=='S3' }">沉睡顾客</c:when>
										<c:when test="${record.aftertype=='X1' }">唤醒瞌睡</c:when>
										<c:when test="${record.aftertype=='X2' }">唤醒半睡</c:when>
										<c:when test="${record.aftertype=='X3' }">唤醒沉睡</c:when>
									</c:choose>
								</td>
								<td><fmt:formatDate value="${record.changetime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div style="clear:both;"></div>
		</div> 
	</form>
  </body>
</html>
