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
    <title>优惠券编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
  	<form name="form1" method="post" id="form1" action="<%=request.getContextPath() %>/coupon/saveCoupon.action" class="l-form">
		<input type="hidden" name="id" value="${coupon.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>优惠券信息</span>
		</div>
		<div class="formitems">
			<div class="item full">
				<div class="label"><span style="color:red">*</span>类型:</div>
				<div class="input">
					<label><input type="radio" name="type" <c:if test="${coupon.type=='0'||coupon.type==null}">checked="checked"</c:if> value="0"/>用户兑换</label>
					<label><input type="radio" name="type" <c:if test="${coupon.type=='1'}">checked="checked"</c:if> value="1"/>现金购买</label>
					<label><input type="radio" name="type" <c:if test="${coupon.type=='2'}">checked="checked"</c:if> value="2"/>系统发放</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>优惠券名称:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${coupon.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>副标题:</div>
				<div class="input">
					<input name="subtitle" type="text" id="subtitle" value="${coupon.subtitle}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">图片:</div>
				<div class="input">
					<img src="${basePath }${coupon.logourl}" onclick='showImg(this)' onerror="defaultImg(this)" id="logourl" width="90" height="90"/>
					<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'logourl','logourl')" id="typeicon"/>
					<input type="hidden" name="logourl" value="${coupon.logourl }"/>
				</div>
			</div>
			<div class="item">
				<div class="label">数量:</div>
				<div class="input">
					<input name="amount" type="text" id="amount" value="${coupon.amount}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">面值:</div>
				<div class="input">
					<input name="money" type="text" id="money" value="${coupon.money}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>有效期类型:</div>
				<div class="input">
					<label><input type="radio" name="timetype" <c:if test="${coupon.timetype=='0'||coupon.timetype==null}">checked="checked"</c:if> value="0"/>固定期限</label>
					<label><input type="radio" name="timetype" <c:if test="${coupon.timetype=='1'}">checked="checked"</c:if> value="1"/>固定天数</label>
				</div>
			</div>
			<div class="item days">
				<div class="label">天数:</div>
				<div class="input">
					<input name="days" type="text" id="days" value="${coupon.days}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item times">
				<div class="label">开始时间:</div>
				<div class="input">
					<input name="starttime" type="text" id="starttime" onclick="WdatePicker()" class="easyui-validatebox Wdate" data-options="required:true" value="<fmt:formatDate value="${coupon.starttime}" pattern="yyyy-MM-dd"/>"/>
				</div>
			</div>
			<div class="item times">
				<div class="label">结束时间:</div>
				<div class="input">
					<input name="endtime" type="text" id="endtime" onclick="WdatePicker()" class="easyui-validatebox Wdate" data-options="required:true" value='<fmt:formatDate value="${coupon.endtime}" pattern="yyyy-MM-dd"/>'/>
				</div>
			</div>
			<div class="item">
				<div class="label">价格:</div>
				<div class="input">
					<input name="price" type="text" id="price" value="${coupon.price}" data-options="required:true,validType:['moreThanZero']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">兑换积分:</div>
				<div class="input">
					<input name="integral" type="text" id="integral" value="${coupon.integral}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">兑换上限:</div>
				<div class="input">
					<input name="maxget" type="text" id="maxget" value="${coupon.maxget}" data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">兑换级别起点:</div>
				<div class="input">
					<select name="getgrade" class="easyui-combobox" data-options="editable:false" style="width:137px;">
						<c:forEach items="${levelSettings }" var="level">
						<option <c:if test="${level.grade==coupon.getgrade }">selected="selected"</c:if> value="${level.grade }">${level.gradename }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>状态:</div>
				<div class="input">
					<select class="easyui-combobox" style="width:150px;" data-options="editable:false" name="status">
						<option <c:if test="${coupon.status=='0'}">selected="selected"</c:if> value="0">正常</option>
						<option <c:if test="${coupon.status=='1'}">selected="selected"</c:if> value="1">禁用</option>
					</select>
				</div>
			</div>
			<div class="item full">
				<div class="label">描述:</div>
				<div class="input">
					<textarea rows="5" cols="70" name="remark">${coupon.remark }</textarea>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveCoupon()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
	
	<script type="text/javascript">
		function saveCoupon(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			$.post("<%=request.getContextPath()%>/coupon/saveCoupon.action",$("#form1").serializeArray(),function(data){
				searchCoupon();
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
		
		$(function(){
			$("input[name='type']").click(function(){
				$("#price").validatebox({required:false});
				$("#price").parent().parent().hide();
				$("#integral").validatebox({required:false});
				$("#integral").parent().parent().hide();
				if($(this).val()=="0"){
					$("#integral").validatebox({required:true});
					$("#integral").parent().parent().show();
				}
				else if($(this).val()=="1"){
					$("#price").validatebox({required:true});
					$("#price").parent().parent().show();
				}
				else{
					
				}
			});
			$("input[name='timetype']").click(function(){
				$(".times input[type='text']").validatebox({required:false});
				$(".times").hide();
				$(".days input[type='text']").validatebox({required:false});
				$(".days").hide();
				if($(this).val()=="0"){
					$(".times input[type='text']").validatebox({required:true});
					$(".times").show();
				}
				else if($(this).val()=="1"){
					$(".days input[type='text']").validatebox({required:true});
					$(".days").show();
				}
			});
			
			setTimeout(function(){
				$("input[name='type']:checked").click();
				$("input[name='timetype']:checked").click();
			}, 100);
		});
	</script>
  </body>
</html>
