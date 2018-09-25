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
    <title>菜单编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveMenu(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/menu/saveMenu.action",$("#form1").serializeArray(),function(data){
				searchMenu();
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
		
		$(function(){
		});
	</script>
  	<form name="form1" method="post" id="form1" action="<%=request.getContextPath() %>/menu/saveMenu.action" class="l-form">
		<input type="hidden" name="id" value="${menu.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>菜单信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>菜单名称:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${menu.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>类型:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="type">
						<option <c:if test="${menu.type=='1'}">selected="selected"</c:if> value="1">管理菜单</option>
						<option <c:if test="${menu.type=='2'}">selected="selected"</c:if> value="2">前台菜单</option>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label">url:</div>
				<div class="input">
					<input name="url" type="text" id="url" value="${menu.url}" data-options="validType:['length[1,500]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">图标:</div>
				<div class="input">
					<input name="icon" type="text" id="icon" value="${menu.icon}" data-options="validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">父菜单:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="pid" id="pid">
						<option value="">---请选择---</option>
						<c:forEach items="${parents}" var="parent">
							<option <c:if test="${parent.id==menu.pid}">selected="selected"</c:if> value="${parent.id}">${parent.name}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label">排序:</div>
				<div class="input">
					<input name="sortby" type="text" id="sortby" value="${menu.sortby}" data-options="validType:['length[1,5]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>状态:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="status">
						<option <c:if test="${menu.status=='0'}">selected="selected"</c:if> value="0">正常</option>
						<option <c:if test="${menu.status=='1'}">selected="selected"</c:if> value="1">禁用</option>
					</select>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveMenu()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
