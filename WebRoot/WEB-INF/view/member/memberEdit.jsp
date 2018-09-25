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
    <title>会员编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveMember(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			if(!$("#memberlevel").val()){
				$.messager.alert('提示','请选择会员等级','info');
				return false;
			}
			$.post("<%=request.getContextPath()%>/member/saveMember.action",$("#form1").serializeArray(),function(data){
				searchList();
				$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
			});
		}
		
		function getChildren(t){
			var code=$(t).val();
			if(code){
				$.ajax({
					url:'${ctx}/manage/getChildrenArea.action',
					data:{
						parent:code
					},
					dataType:'json',
					success:function(data){
						$(t).next("select").find("option:gt(0)").remove();
						var html="";
						for(var i=0;i<data.length;i++){
							html+="<option value='"+data[i].code+"'>"+data[i].name+"</option>";
						}
						$(t).next("select").append(html);
					}
				});
			}
		}
		
		function gradeSelect(record){
			if($("#memberlevel").val()){
				$("#discount").val($("#memberlevel option:selected").attr("data-discount"));
			}
		}
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${member.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>会员信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>姓名:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${member.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>性别:</div>
				<div class="input">
					<label><input type="radio" name="sex" <c:if test="${member.sex=='0' ||member.sex==null }">checked="checked"</c:if> value="0"/>男</label>
					<label><input type="radio" name="sex" <c:if test="${member.sex=='1' }">checked="checked"</c:if> value="1"/>女</label>
				</div>
			</div>
			<div class="item">
				<div class="label">出生日期:</div>
				<div class="input">
					<input name="birthday" type="text" id="birthday" value="<fmt:formatDate value='${member.birthday}' pattern='yyyy-MM-dd'/>" class="easyui-datebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>联系电话:</div>
				<div class="input">
					<input name="phone" type="text" id="phone" value="${member.phone}" data-options="required:true,validType:['isTelorMobile']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">会员积分:</div>
				<div class="input">
					${member.memberpoint }
				</div>
			</div>
			<div class="item ">
				<div class="label"><span style="color:red">*</span>会员等级:</div>
				<div class="input">
					<select name="memberlevel" id="memberlevel" onchange="gradeSelect()">
						<option value="">请选择会员等级</option>
						<c:forEach items="${levelSettings }" var="ls">
							<option data-discount="${ls.discount }" <c:if test="${ls.grade==member.memberlevel }">selected="selected"</c:if> value="${ls.grade }">${ls.gradename }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<c:if test="${not empty memberAddresses }">
			<div class="item full">
				<div class="label">地址:</div>
			</div>
			<div style="clear:both"></div>
			<c:forEach items="${memberAddresses }" var="address">
				<div style="margin-left:75px;">${address.address }<c:if test="${address.isdefault=='1' }">(默认)</c:if></div>
			</c:forEach>
			<div style="clear:both;margin-bottom: 5px;"></div>
			</c:if>
			<%-- <div class="item full">
				<div class="label">地址:</div>
				<select onchange="getChildren(this)">
					<option value="">请选择省</option>
					<c:forEach items="${provinces }" var="pro">
						<option <c:if test="${region.provincecode==pro.code }">selected="selected"</c:if> value="${pro.code }">${pro.name }</option>
					</c:forEach>
				</select>
				<select onchange="getChildren(this)">
					<c:if test="${region==null }">
						<option value="">请选择市</option>
					</c:if>
					<c:if test="${region!=null }">
						<option value="">请选择市</option>
						<option selected="selected" value="${region.citycode }">${region.cityname }</option>
					</c:if>
				</select>
				<select name="addressid">
					<c:if test="${region==null }">
						<option value="">请选择区县</option>
					</c:if>
					<c:if test="${region!=null }">
						<option value="">请选择区县</option>
						<option selected="selected" value="${region.code }">${region.name }</option>
					</c:if>
				</select>
			</div>
			<div class="item full">
				<div class="label">详细地址:</div>
				<div class="input">
					<input name="detailaddress" style="width:431px;" type="text" id="detailaddress" value="${member.detailaddress}" data-options="validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div> --%>
			<div class="item full">
				<div class="label"><span style="color:red">*</span>折扣:</div>
				<div class="input">
					<input name="discount" style="width:431px;" type="text" id="discount" value="${member.discount}" data-options="required:true,validType:['moreThanOrEqualZero','notMoreThanNum[\'10\']']" class="easyui-validatebox"/>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveMember()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
