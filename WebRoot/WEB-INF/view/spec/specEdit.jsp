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
    <title>规格编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
  	<script type="text/javascript">
		function saveSpec(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/spec/saveSpec.action",$("#form1").serializeArray(),function(data){
				searchSpec();
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
		
		function nameExists(value){
			var typecode=$("input[name='typecode']:checked").val();
			var result = $.ajax({
			    url:'<%=request.getContextPath()%>/spec/nameExists.action?typecode='+typecode+'&specvalue='+value,
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
				nameCheck: {
			        validator: function (value, param) {
			            return nameExists(value);
			        },
			        message: '规则已存在,请重新输入!'
			    }
			});
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${spec.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>规格信息</span>
		</div>
		<div class="formitems">
			<div class="item full">
				<div class="label"><span style="color:red">*</span>类型:</div>
				<div class="input">
					<label><input type="radio" name="typecode" <c:if test="${spec.typecode=='color'||spec.typecode==null}">checked="checked"</c:if> value="color"/>颜色</label>
					<label><input type="radio" name="typecode" <c:if test="${spec.typecode=='size'}">checked="checked"</c:if> value="size"/>尺码</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>规格名称:</div>
				<div class="input">
					<input name="specvalue" type="text" id="specvalue" value="${spec.specvalue}" data-options="required:true,validType:['length[1,50]','nameCheck']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">排序:</div>
				<div class="input">
					<input name="sortno" type="text" id="sortno" value="${spec.sortno==null?0:spec.sortno}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveSpec()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
