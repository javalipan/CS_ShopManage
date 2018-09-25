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
    <title>用户编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveUser(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/user/saveUser.action",$("#form1").serializeArray(),function(data){
				searchUser();
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
		
		function userExists(value){
			var result = $.ajax({
			    url:'<%=request.getContextPath()%>/user/loginnameExists.do?loginname='+value,
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
			    userExistsCheck: {
			        validator: function (value, param) {
			            return userExists(value);
			        },
			        message: '登录名已存在,请重新输入!'
			    }
			});
		});
	</script>
  	<form name="form1" method="post" id="form1" action="<%=request.getContextPath() %>/user/saveUser.action" class="l-form">
		<input type="hidden" name="id" value="${user.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>用户信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>姓名:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${user.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">身份证号码:</div>
				<div class="input">
					<input name="idnum" type="text" id="idnum" value="${user.idnum}" data-options="validType:['length[1,18]','idcard']" class="easyui-validatebox"/>
				</div>
			</div>
			<c:if test="${user.id==null}">
				<div class="item">
					<div class="label"><span style="color:red">*</span>登录名:</div>
					<div class="input">
						<input name="loginname" type="text" id="loginname" data-options="required:true,validType:['length[1,20]','loginName','userExistsCheck']" class="easyui-validatebox"/>
					</div>
				</div>
				<div class="item">
					<div class="label"><span style="color:red">*</span>密码:</div>
					<div class="input">
						<input name="password" type="password" id="password" data-options="required:true,validType:['length[1,30]','safepass']" class="easyui-validatebox"/>
					</div>
				</div>
			</c:if>
			<div class="item">
				<div class="label">性别:</div>
				<div class="input">
					<input type="radio" name="sex" <c:if test="${user.sex=='0'||user.id==null }">checked=checked</c:if> value="0"/>男<input type="radio" name="sex" <c:if test="${user.sex=='1' }">checked=checked</c:if> value="1"/>女
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>生日:</div>
				<div class="input">
					<input id="birthday" name="birthday" type="text" editable="fasle" value="<fmt:formatDate value="${user.birthday}" pattern="yyyy-MM-dd"/>"  class="easyui-datebox" required="required"></input>
				</div>
			</div>
			<div class="item">
				<div class="label">手机:</div>
				<div class="input">
					<input name="mobilephone" type="text" id="mobilephone" value="${user.mobilephone}" data-options="validType:['length[1,11]','mobile']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">座机:</div>
				<div class="input">
					<input name="phone" type="text" id="mobilephone" value="${user.phone}" data-options="validType:['length[1,15]','isTel']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">邮箱:</div>
				<div class="input">
					<input name="email" type="text" id="email" value="${user.email}" data-options="validType:['length[1,50]','email']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">QQ:</div>
				<div class="input">
					<input name="qq" type="text"  id="qq" value="${user.qq}" data-options="validType:['QQ']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">微信号:</div>
				<div class="input">
					<input name="microletter" type="text" id="microletter" value="${user.microletter}" data-options="validType:['length[1,30]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">邮编:</div>
				<div class="input">
					<input name="zipcode" type="text"  id="zipcode" value="${user.zipcode}" data-options="validType:['ZIP']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>类型:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="type">
						<option <c:if test="${user.type=='2'}">selected="selected"</c:if> value="2">收银员</option>
						<option <c:if test="${user.type=='1'}">selected="selected"</c:if> value="1">管理员</option>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>状态:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="status">
						<option <c:if test="${user.status=='0'}">selected="selected"</c:if> value="0">正常</option>
						<option <c:if test="${user.status=='1'}">selected="selected"</c:if> value="1">禁用</option>
					</select>
				</div>
			</div>
			<div class="item item2">
				<div class="label">地址:</div>
				<div class="input">
					<textarea rows="2" cols="55" name="address" class="easyui-validatebox" data-options="validType:['length[1,500]']">${user.address}</textarea>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveUser()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
