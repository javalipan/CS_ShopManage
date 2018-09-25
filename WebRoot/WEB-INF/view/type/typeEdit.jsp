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
    <title>分类编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveType(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/type/saveType.action",$("#form1").serializeArray(),function(data){
				$('#typeTable').treegrid("reload");
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
		
		function typecode(value){
			var result = $.ajax({
			    url:'<%=request.getContextPath()%>/type/codeExists.action?id=${type.id}&code='+value,
			    async:false,
			    cache:false,
			    dataType:"text"
				}).responseText;
				if(result.charCodeAt()=="true".charCodeAt()){
					return false;
				}
				else{
					return true;
				}
		}
		
		$(function(){
			$.extend($.fn.validatebox.defaults.rules, {
				typecode: {
			        validator: function (value, param) {
			            return typecode(value);
			        },
			        message: '编码重复,请重新输入'
			    }
			});
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${type.id}"/>
		<input type="hidden" name="parentcode" value="${type.parentcode}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>分类信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>编号:</div>
				<div class="input">
					<input name="code" type="text" id="code" value="${type.code}" data-options="required:true,validType:['typecode']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>分类名称:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${type.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">排序:</div>
				<div class="input">
					<input name="sortno" type="text" id="sortno" value="${type.sortno==null?0:type.sortno}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveType()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
