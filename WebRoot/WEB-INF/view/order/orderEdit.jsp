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
    <title>订单编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveOrder(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/order/saveOrder.action",$("#form1").serializeArray(),function(data){
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
				searchOrder();
			}); 
		}
		
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${order.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>订单信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>订单类型</div>
				<div class="input">
					<label><input type="radio" name="type" <c:if test="${order.type=='0' }">checked</c:if> value="0" />微信线上订单</label>
					<label><input type="radio" name="type" <c:if test="${order.type=='1' }">checked</c:if> value="1" />线下订单</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>订单金额</div>
				<div class="input">
					<input name="totalprice" type="text" id="totalprice" value="${order.totalprice}"data-options="required:true,validType:['moreThanZero']" class="easyui-validatebox"/>
				</div>
			</div>
			<c:if test="${order.type=='0' }">
			<div class="item">
				<div class="label">联系人</div>
				<div class="input">
					<input name="reveivename" type="text" id="reveivename" value="${order.reveivename}"data-options="validType:['length[0,10]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">联系电话</div>
				<div class="input">
					<input name="phone" type="text" id="phone" value="${order.phone}"data-options="validType:['isTelorMobile']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">地址</div>
				<div class="input">
					<input name="address" type="text" id="address" value="${order.address}"data-options="validType:['length[0,200]']" class="easyui-validatebox"/>
				</div>
			</div>
			</c:if>
			<div class="item full">
				<div class="label">备注:</div>
				<div class="input">
					<textarea rows="5" cols="70" name="remark">${order.remark }</textarea>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveOrder()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
