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
    <title>会员标签</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
  	<style>
	.formitems .item{ background: #e8e4e4;width: 130px;margin-left: 5px;height: 30px;line-height: 30px;text-align: center;border-radius: 15px;	}
	.formitems .item label{ display: block;float: right;margin-right:8px;cursor: pointer;	}
	</style>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="memberid" value="${id}"/>
		添加标签：<select id="labelName" class="easyui-combobox" data-options="editable:false" style="width:140px;">
			<c:forEach items="${codes }" var="code">
				<option value="${code.name }">${code.name }</option>
			</c:forEach>
		</select>
		<a href="javascript:void(0)" id="addBtn" style="display: inline-block;vertical-align:top;"><img src="${ctx }/images/add.png"/></a>
		
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>会员标签</span>
		</div>
		<div class="formitems">
			<c:forEach items="${memberLabels }" var="label">
				<c:if test="${label.labelname!='' }">
					<div class="item" js-id="${label.id }" js-issystem="${label.issystem }" js-typecode="${label.typecode}">
						${label.labelname }<c:if test="${label.issystem=='0' }"><label onclick="deleteItem(this,${label.id})" class="deleteBtn">X</label></c:if>
					</div>
				</c:if>
			</c:forEach>
			<div style="clear:both;"></div>
		</div>
	</form>
	
	<script type="text/javascript">
		$("#addBtn").click(function(){
			var label=$("#labelName").combobox("getValue");
			var memberid=$("input[name='memberid']").val();
			$.ajax({
				url:"${ctx}/member/saveLabel.action",
				data:{
					memberid:memberid,
					typecode:'',
					typename:'',
					labelname:label,
					issystem:'0'
				},
				type:"POST",
				dataType:"json",
				success:function(result){
					if(result.success){
						$(".formitems .item:last").after("<div class='item' js-id='"+result.data.id+"' js-issystem='"+result.data.issystem+"'>"+result.data.labelname+"<label class='deleteBtn' onclick='deleteItem(this,"+result.data.id+")'>X</label></div>");
						$.messager.alert('提示',"保存成功",'info');
					}
					else{
						$.messager.alert('提示',result.msg,'info');
					}
				}
			});
		});
		
		function deleteItem(t,id){
			$.messager.confirm('提示','您确认要删除该标签吗?',function(result){
		        if (result){
					$.ajax({
						url:"${ctx}/member/deleteLabel.action",
						data:{
							id:id
						},
						success:function(result){
							$(t).parent().remove();
							$.messager.alert('提示',result,'info');
						}
					});
		        }
			});
		}
	</script>
  </body>
</html>
