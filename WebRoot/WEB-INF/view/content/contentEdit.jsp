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
    <title>内容编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveContent(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/content/saveContent.action",$("#form1").serializeArray(),function(data){
				searchContent();
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
                    $("#"+obj1).attr("src", "${basePath}"+data.filePath);
                    $("input[name='"+obj2+"']").val(data.filePath);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    alert(e);
                }
            });
		}
		
		var ue;
		$(function(){
			ue=UE.getEditor('ueditor',{initialFrameWidth :500,initialFrameHeight :300,wordCount:false});
			ue.ready(function() {
				ue.setContent('${content.content }');
			});
			$(".window").css("zIndex",9);
			$(".window-shadow").css("zIndex",8);
			$(".window-mask").css("zIndex",7);
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${content.id}"/>
		<input type="hidden" name="programid" value="${content.programid}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>内容信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>标题:</div>
				<div class="input">
					<input name="title" type="text" id="title" value="${content.title}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>副标题:</div>
				<div class="input">
					<input name="subtitle" type="text" id="subtitle" value="${content.subtitle}" data-options="validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">开始时间:</div>
				<div class="input">
					<input name="starttime" type="text" id="starttime" class="easyui-datebox" value="${content.starttime}"/>
				</div>
			</div>
			<div class="item">
				<div class="label">结束时间:</div>
				<div class="input">
					<input name="endtime" type="text" id="endtime" class="easyui-datebox" value="${content.endtime}"/>
				</div>
			</div>
			<div class="item full">
				<div class="label">url:</div>
				<div class="input">
					<input name="url" type="text" id="url" value="${content.url}" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item full">
				<div class="label">排序:</div>
				<div class="input">
					<input name="sortno" type="text" id="sortno" value="${content.sortno}" data-options="validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">图片:</div>
				<div class="input">
					<img src="${basePath }${content.img}" onclick='showImg(this)' onerror="defaultImg(this)" id="img" width="90" height="90"/>
					<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img','img')" id="typeicon"/>
					<input type="hidden" name="img" value="${content.img }"/>
				</div>
			</div>
			<div class="item">
				<div class="label">备注:</div>
				<div class="input">
					<textarea rows="5" name="comments" cols="30">${content.comments }</textarea>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div class="item full">
				<div class="label">内容:</div>
				<div class="input">
					<script id="ueditor" name="content" style="height:300px;"></script>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveContent()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
