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
    <title>系统参数 </title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<style>
	table{ padding:0; margin:0;border-collapse:collapse; margin:10px auto;margin-top:20px;}
	table tr td{ border:#dbd9d3 solid 1px;height:35px;text-align:center;}
	table tr td input{ border:0 none; outline:none;}
	</style>
	<script type="text/javascript">
	function saveOptions(){
		var flag = $('#form1').form('validate');
		if(!flag) {
			return false;
		}
		
		var options=[] ;
		$(".options").each(function(){
			var id = $(this).find("input").val() ,
			optvalue = $(this).next().find("input").val() ;
			options.push({id:id,optvalue:optvalue}) ;
		}) ;
		
		$.ajax({
			url:"${ctx}/set/saveSetting.action" ,
			data:{json:JSON.stringify(options)},
			success:function(data){
				if(data){
					$.messager.alert('提示',"保存成功",'info');
				}
			}
		}) ; 
	}
	</script>
  </head>
  
  <body>
  <form name="form1" method="post" id="form1" class="l-form">
	<table>
		<c:forEach items="${sysSettings }" var="setting" varStatus="i">
			<tr>
				<td class="options" bgcolor="#f3f3f1" style="width:5%;"><input type="hidden" value="${setting.id }" />${setting.remark }</td>
	        	<td style="width:5%;">
       				<input name="typevalue" style="width:80%;text-align:center;" class="easyui-validatebox" data-options="required:true" type="text"  value="${setting.typevalue }" />
	        	</td>
		    </tr>
		</c:forEach>
	</table>
	</form>
	<div style="text-align: center;"><a id="btn" onclick="saveOptions()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>  </div>
  </body>
</html>
