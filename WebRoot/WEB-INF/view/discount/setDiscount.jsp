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
    <title>设置折扣</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveDiscount(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/discount/setDiscount.action",$("#form1").serializeArray(),function(data){
				searchGoods();
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="ids" value="${ids}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>折扣信息</span>
		</div>
		<div class="formitems">
			<div class="item full">
				<div class="label"><span style="color:red">*</span>折扣:</div>
				<div class="input">
					<input name="discount" type="text" id="discount" data-options="required:true,validType:['moreThanOrEqualZero','notMoreThanNum[\'10\']']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>开始时间:</div>
				<div class="input">
					<input type="text" name="starttime" id="starttime" data-options="required:true" class="easyui-datebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>结束时间:</div>
				<div class="input">
					<input type="text" name="endtime" id="endtime" data-options="required:true" class="easyui-datebox"/>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveDiscount()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">确定</a>
		</div>
	</form>
  </body>
</html>
