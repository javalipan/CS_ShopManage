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
    <title>订单详情</title>
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
			<span>订单信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label">订单编号:</div>
				<div class="input">${order.code}</div>
			</div>
			<div class="item">
				<div class="label">会员:</div>
				<div class="input">${order.membernickname}</div>
			</div>
			<div class="item">
				<div class="label">类型:</div>
				<div class="input">${order.type=="0"?"微信订单":"线下订单"}</div>
			</div>
			<div class="item">
				<div class="label">优惠前金额:</div>
				<div class="input">${order.oldprice}元</div>
			</div>
			<div class="item">
				<div class="label">会员折扣:</div>
				<div class="input">${order.discount}折</div>
			</div>
			<div class="item">
				<div class="label">积分抵换:</div>
				<div class="input">${order.integralprice}</div>
			</div>
			<c:if test="${order.pricemodified=='1' }">
				<div class="item">
					<div class="label">修改金额:</div>
					<div class="input">${order.pricemodified=="0"?"否":"是"}</div>
				</div>
				<div class="item">
					<div class="label">修改人:</div>
					<div class="input">${order.modifyUserName}</div>
				</div>
			</c:if>
			<div class="item">
				<div class="label">支付金额:</div>
				<div class="input">${order.totalprice}元</div>
			</div>
			<div class="item">
				<div class="label">余额支付:</div>
				<div class="input">${order.balancepay}元</div>
			</div>
			<div class="item">
				<div class="label">优惠券支付:</div>
				<div class="input">${order.couponspay}元</div>
			</div>
			<div class="item">
				<div class="label">满减:</div>
				<div class="input">${order.subtractmoney}元</div>
			</div>
			<div class="item">
				<div class="label">使用优惠券:</div>
				<div class="input" style="overflow: hidden;" title="${order.usercoupons}">${order.usercoupons}</div>
			</div>
			<div class="item">
				<div class="label">获得积分:</div>
				<div class="input">${order.integral}</div>
			</div>
			<div class="item">
				<div class="label">是否支付:</div>
				<div class="input">${order.ispay=="0"?"未支付":"已支付"}</div>
			</div>
			<c:if test="${order.ispay=='1' }">
				<div class="item">
					<div class="label">支付时间:</div>
					<div class="input"><fmt:formatDate value="${order.paytime }" pattern="yyyy-MM-dd HH:mm:ss"/></div>
				</div>
			</c:if>
			<div class="item">
				<div class="label">是否发货:</div>
				<div class="input">${order.issend=="0"?"未发货":"已发货"}</div>
			</div>
			<c:if test="${order.issend=='1' }">
				<div class="item">
					<div class="label">发货时间:</div>
					<div class="input"><fmt:formatDate value="${order.sendtime }" pattern="yyyy-MM-dd HH:mm:ss"/></div>
				</div>
			</c:if>
			<div class="item">
				<div class="label">是否收货:</div>
				<div class="input">${order.isreceive=="0"?"未收货":"已收货"}</div>
			</div>
			<c:if test="${order.receivetime=='1' }">
				<div class="item">
					<div class="label">收货时间:</div>
					<div class="input"><fmt:formatDate value="${order.receivetime }" pattern="yyyy-MM-dd HH:mm:ss"/></div>
				</div>
			</c:if>
			<div class="item">
				<div class="label">配送方式:</div>
				<div class="input">${order.delway=="0"?"商家配送":"到店自提"}</div>
			</div>
			<div class="item">
				<div class="label">下单时间:</div>
				<div class="input"><fmt:formatDate value="${order.ordertime }" pattern="yyyy-MM-dd HH:mm:ss"/></div>
			</div>
			<div class="item">
				<div class="label">支付方式:</div>
				<div class="input">
					<c:choose>
						<c:when test="${order.payway=='0' }">微信支付</c:when>
						<c:when test="${order.payway=='1' }">现金支付</c:when>
						<c:when test="${order.payway=='2' }">支付宝</c:when>
						<c:when test="${order.payway=='3' }">银行卡</c:when>
					</c:choose>
				</div>
			</div>
			<c:if test="${order.delway=='0' }">
				<div class="item">
					<div class="label">收货人姓名:</div>
					<div class="input">${order.reveivename }</div>
				</div>
				<div class="item">
					<div class="label">收货人电话:</div>
					<div class="input">${order.phone }</div>
				</div>
				<div class="item">
					<div class="label">收货人地址:</div>
					<div class="input">${order.address }</div>
				</div>
			</c:if>
			<c:if test="${order.delway=='1' }">
				<div class="item">
					<div class="label">提货时间:</div>
					<div class="input"><fmt:formatDate value="${order.gettime }" pattern="yyyy-MM-dd HH:mm:ss"/></div>
				</div>
			</c:if>
			<div class="item full">
					<div class="label">备注:</div>
					${order.remark }
				</div>
			<div class="tableDiv clearfix">
				<table class="table-product" id="dptable">
					<thead>
						<tr>
							<th>序号</th>
							<th>品牌</th>
							<th>商品名称</th>
							<th>尺寸</th>
							<th>颜色</th>
							<th>成本价</th>
							<th>吊牌价</th>
							<th>成交价</th>
							<th>折扣</th>
							<th>折扣价</th>
							<th>数量</th>
							<th>均价</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${details }" var="detail" varStatus="status">
							<tr>
								<td>${status.index+1 }</td>
								<td>${detail.brandName }</td>
								<td>${detail.goodsName }</td>
								<td>${detail.sizeName }</td>
								<td>${detail.colorName }</td>
								<td>${detail.costprice }</td>
								<td>${detail.oldprice }</td>
								<td>${detail.price }</td>
								<td>${detail.discount }</td>
								<td>${detail.vipprice }</td>
								<td>${detail.amount }</td>
								<td>${detail.avgprice }</td>
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
