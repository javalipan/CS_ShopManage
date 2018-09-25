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
    <title>预约编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveSchedule(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/appoint/saveAppointment.action",$("#form1").serializeArray(),function(data){
				$.messager.alert('提示',data,'info',function(){
					location.reload();
				});
			});
		}
		
		$(function(){
			
			$("#memberid").combobox({    
			    url:'${ctx}/member/getAllMembers.action',  
			    valueField:'id',    
			    textField:'text',
			    width:147,
			    height:20,
			    required:true,
			    validType:"mustSelect['#memberid']",
			    onLoadSuccess:function(){
			    	if("${schedule.memberid}"){
			    		$("#memberid").combobox("setValue","${schedule.memberid}");
			    	}
			    }
			});  
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${schedule.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>预约信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>会员:</div>
				<div class="input">
					<input id="memberid" name="memberid" />  
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>联系人姓名:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${schedule.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">联系电话:</div>
				<div class="input">
					<input name="phone" type="text" id="phone" value="${schedule.phone}" data-options="required:true,validType:['isTelorMobile']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">联系地址:</div>
				<div class="input">
					<input name="address" type="text" id="address" value="${schedule.address}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">预约时间:</div>
				<div class="input">
					<input name="starttime" type="text" id="starttime" value="<fmt:formatDate value='${schedule.starttime}' pattern='yyyy-MM-dd HH:mm:ss'/>" data-options="required:true" class="easyui-datetimebox"/>
				</div>
			</div>
			<div class="item full">
				<div class="label">备注:</div>
				<div class="input">
					<textarea rows="5" cols="70" name="remark">${schedule.remark }</textarea>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveSchedule()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
