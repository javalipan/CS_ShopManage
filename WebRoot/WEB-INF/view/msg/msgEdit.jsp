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
		function saveMsg(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/msg/saveMsg.action",$("#form1").serializeArray(),function(data){
				searchMsg();
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
		
		function upload(t,obj1,obj2){
			var id=$(t).attr("id");
			$.ajaxFileUpload({
                url: '${ctx}/attachment/uploadFile.action', //用于文件上传的服务器端请求地址
                secureuri: false, //是否需要安全协议，一般设置为false
                fileElementId: id, //文件上传域的ID
                dataType: 'json', //返回值类型 一般设置为json
                success: function (data, status)  //服务器成功响应处理函数
                {
                    $("#"+obj1).attr("src", "${urlprev}"+data.filePath);
                    $("input[name='"+obj2+"']").val("${urlprev}"+data.filePath);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    alert(e);
                }
            });
		}
		
		$(function(){
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${msg.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>消息信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>标题:</div>
				<div class="input">
					<input name="title" type="text" id="title" value="${msg.title}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>类型:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="msgtype">
						<option <c:if test="${msg.msgtype=='1'}">selected="selected"</c:if> value="1">文字消息</option>
						<option <c:if test="${msg.msgtype=='2'}">selected="selected"</c:if> value="2">图片消息</option>
						<option <c:if test="${msg.msgtype=='3'}">selected="selected"</c:if> value="3">视频消息</option>
						<option <c:if test="${msg.msgtype=='4'}">selected="selected"</c:if> value="4">小视频消息</option>
						<option <c:if test="${msg.msgtype=='5'}">selected="selected"</c:if> value="5">位置消息</option>
						<option <c:if test="${msg.msgtype=='6'}">selected="selected"</c:if> value="6">收到链接</option>
						<option <c:if test="${msg.msgtype=='7'}">selected="selected"</c:if> value="7">订阅</option>
						<option <c:if test="${msg.msgtype=='8'}">selected="selected"</c:if> value="8">取消订阅</option>
						<option <c:if test="${msg.msgtype=='9'}">selected="selected"</c:if> value="9">点击菜单</option>
						<option <c:if test="${msg.msgtype=='10'}">selected="selected"</c:if> value="10">点击链接菜单</option>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>图片:</div>
				<div class="input">
					<img src="${msg.picaddr}" onerror="defaultImg(this)" id="picaddr" width="90" height="90"/>
					<input type="file" class="imgupload" name="picaddrfile" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'picaddr','picaddr')" id="typeicon"/>
					<input type="hidden" name="picaddr" value="${msg.picaddr }"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>内容类型:</div>
				<div class="input">
					<label><input type="radio" name="contenttype" value="1" checked="checked"/>链接</label>
					<label><input type="radio" name="contenttype" value="2" disabled="disabled"/>富文本</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>链接:</div>
				<div class="input">
					<input name="linkaddr" type="text" id="linkaddr" value="${msg.linkaddr}" data-options="required:true,validType:['length[1,500]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">排序:</div>
				<div class="input">
					<input name="fdorder" type="text" id="fdorder" value="${msg.fdorder}" data-options="validType:['length[1,10]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveMsg()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
