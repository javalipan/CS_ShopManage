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
    <title>会员充值</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveRecharge(){
			var data={};
			if(!$("#sdcz").is(":checked")){
				if($("#auto select[name='amount']").val()){
					data={
						id:${member.id},
						ruleid:$("#auto select[name='amount'] option:selected").attr("id")
					}
				}
				else{
					$.messager.alert('提示',"请选择充值金额",'info');
					return;
				}
			}
			else{
				if(!$("#sd input[name='amount']").val()){
					$.messager.alert('提示',"请输入充值金额",'info');
					return;
				}
				if(!/^\d+$/.test($("#sd input[name='amount']").val())){
					$.messager.alert('提示',"充值金额输入不合法",'info');
					return;
				}
				if(!$("#sd input[name='giveamount']").val()){
					$.messager.alert('提示',"请输入赠送金额",'info');
					return;
				}
				if(!/^\d+$/.test($("#sd input[name='giveamount']").val())){
					$.messager.alert('提示',"赠送金额输入不合法",'info');
					return;
				}
				if(!$("#sd input[name='discount']").val()){
					$.messager.alert('提示',"请输入折扣",'info');
					return;
				}
				if(isNaN($("#sd input[name='discount']").val())||parseFloat($("#sd input[name='discount']").val())<0||$("#sd input[name='discount']").val()>10){
					$.messager.alert('提示',"折扣应大于0小于10",'info');
					return;
				}
				data={
					id:${member.id},
					amount:$("#sd input[name='amount']").val(),
					giveamount:$("#sd input[name='giveamount']").val(),
					discount:$("#sd input[name='discount']").val()
				};
			}
			$.ajax({
				url:'${ctx}/member/recharge.action',
				data:data,
				success:function(result){
					searchList();
					$("#dialog").dialog("close");
					$.messager.alert('提示',result,'info');
				}
			});
		}
		
		$(function(){
			$("#auto select[name='amount']").change(function(){
				if($(this).val()){
					$("#auto #giveamount").text($("#auto select[name='amount'] option:selected").attr("giveamount")+"元");
					$("#auto #discount").text($("#auto select[name='amount'] option:selected").attr("discount")+"折");
				}
				else{
					$("#auto #giveamount").text("");
					$("#auto #discount").text("");
				}
			});
			
			$("#sdcz").click(function(){
				if($(this).is(":checked")){
					$("#auto select[name='amount']").attr("disabled","disabled");
					$("#auto #giveamount").text("");
					$("#auto #discount").text("");
					
					$("#sd input[name='amount']").attr("disabled",false);
					$("#sd input[name='giveamount']").attr("disabled",false);
					$("#sd input[name='discount']").attr("disabled",false);
				}
				else{
					$("#auto select[name='amount']").attr("disabled",false);
					
					$("#sd input[name='amount']").attr("disabled","disabled");
					$("#sd input[name='giveamount']").attr("disabled","disabled");
					$("#sd input[name='discount']").attr("disabled","disabled");
					$("#sd input[name='amount']").val("");
					$("#sd input[name='giveamount']").val("");
					$("#sd input[name='discount']").val("");
				}
			});
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${member.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>会员充值</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label">姓名:</div>${member.name}(${member.nickname })
			</div>
			<div class="item">
				<div class="label">当前余额:</div>${member.balance }元，当前折扣:${member.discount<=0?10:member.discount }折
			</div>
			<div class="item full">
				<div class="label" style="width:100px;">请选择充值项目:</div>
			</div>
			<div style="clear:both;"></div>
			<div style="border: 1px solid #ccc;padding: 5px;" id="auto">
				<div class="item full">
					<div class="label">充值金额:</div>
					<div class="input">
						<select style="width:140px;" name="amount">
							<option value="">请选择充值金额</option>
							<c:forEach items="${rechargeRules }" var="rr">
								<option id="${rr.id }" giveamount="${rr.giveamount }" discount="${rr.discount }" value="${rr.amount }">${rr.amount }</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="item">
					<div class="label">赠送金额:</div>
					<div class="input">
						<span id="giveamount"></span>
					</div>
				</div>
				<div class="item">
					<div class="label">商品折扣:</div>
					<div class="input">
						<span id="discount"></span>
					</div>
				</div>
				<div style="clear:both;"></div>
			</div>
			
			<div class="item full">
				<div class="label" style="width:100px;"><label><input type="checkbox" id="sdcz"/>手动充值:</label></div>
			</div>
			<div style="clear:both;"></div>
			<div style="border: 1px solid #ccc;padding: 5px;" id="sd">
				<div class="item">
					<div class="label">充值金额:</div>
					<div class="input">
						<input name="amount" type="text" disabled="disabled" class="easyui-validatebox"/>
					</div>
				</div>
				<div class="item">
					<div class="label">赠送金额:</div>
					<div class="input">
						<input name="giveamount" type="text" disabled="disabled" class="easyui-validatebox"/>
					</div>
				</div>
				<div class="item">
					<div class="label">商品折扣:</div>
					<div class="input">
						<input name="discount" type="text" disabled="disabled" class="easyui-validatebox"/>
					</div>
				</div>
				<div style="clear:both;"></div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveRecharge()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
