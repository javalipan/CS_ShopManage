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
    <title>充值记录</title>
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
			<span>充值记录</span>
		</div>
			<div class="tableDiv clearfix">
				<table class="table-product" id="dptable">
					<thead>
						<tr>
							<th>序号</th>
							<th>金额</th>
							<th>赠送金额</th>
							<th>实际到账金额</th>
							<th>享受折扣</th>
							<th>付款方式</th>
							<th>交易时间</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${recharges }" var="recharge" varStatus="status">
							<tr>
								<td>${status.index+1 }</td>
								<td>${recharge.amount }</td>
								<td>${recharge.giveamount }</td>
								<td>${recharge.realamount }</td>
								<td>${recharge.discount }</td>
								<td>
									<c:choose>
										<c:when test="${recharge.payway=='0' }">银行卡</c:when>
										<c:when test="${recharge.payway=='1' }">微信</c:when>
										<c:when test="${recharge.payway=='2' }">支付宝</c:when>
										<c:when test="${recharge.payway=='3' }">管理员充值</c:when>
									</c:choose>
								</td>
								<td><fmt:formatDate value="${recharge.dealtime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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
