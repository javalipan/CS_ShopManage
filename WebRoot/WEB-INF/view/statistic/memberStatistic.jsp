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
    <title>会员统计</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
			//初始化表格
			$('#dataTable').datagrid({
				title:'会员列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"${ctx}/statistic/member/searchMember.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'memberhead',title:'头像',width:10,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.headurl){
								return "<img onclick='showImg(this)' src='"+row.headurl+"' width='20' height='20'/>";
							}
							else{
								return "";	
							}
						} 
					},
					{field:'nickname',title:'会员昵称',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return row.nickname;}
					},
					{field:'name',title:'姓名',width:20,sortable:false,align:'center'},
					{field:'sex',title:'性别',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.sex=='0'?'男':'女';
						}
					},
					{field:'phone',title:'电话',width:30,sortable:false,align:'center'},
					{field:'memberpoint',title:'会员积分',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a href='${ctx}/pointLog/initPointLogList.action?memberid="+row.id+"'>"+row.memberpoint+"</a>";
						}
					},
					{field:'buycount',title:'消费次数',width:30,sortable:false,align:'center'},
					{field:'totalmoney',title:'累计消费金额',width:30,sortable:false,align:'center'},
					{field:'lastbuytime',title:'最近消费',width:50,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formattime(row.lastbuytime);
						}
					},
					{field:'status',title:'状态',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.status=="0"){
								return "关注";
							}
							else if(row.status=="1"){
								return "取消关注";
							}
							else if(row.status=="2"){
								return "禁用";
							}
						}
					},
					{field:'registertime',title:'关注时间',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.registertime);
						}
					},
					{field:'options',title:'操作',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a class='trbutton' href='javascript:void(0)' onclick='showDetail("+row.id+")'>详情</a>";
						}
					}
				]],
				onLoadSuccess:function(){
					$('#dataTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchList(){
		var params = $('#dataTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#dataTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
			
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchList();
	}
	
	function showDetail(id){
		if(window.parent&&parent.openwindow){
			parent.openwindow("详情",'${ctx}/statistic/member/initDetail.action?id='+id);
		}
		else{
			location.href='${ctx}/statistic/member/initDetail.action?id='+id;
		}
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">会员昵称:</td>
  				<td align="left" width="15%"><input type="text" name="nickname" id="nickname"/></td>
  				<td align="right" width="10%">会员手机:</td>
  				<td align="left" width="15%"><input type="text" name="phone" id="phone"/></td>
  				<td align="right" width="10%">会员姓名:</td>
  				<td align="left" width="15%"><input type="text" name="name" id="name"/></td>
			</tr>
			<tr>
				<td align="right" width="10%">消费时间:</td>
  				<td align="left" width="40%" colspan="3">
  					<input type="text" class="easyui-datebox" name="timeStart" id="timeStart"/>-
  					<input type="text" class="easyui-datebox" name="timeEnd" id="timeEnd"/>
  				</td>
  				<td align="right" width="10%">是否消费:</td>
  				<td align="left" width="15%">
  					<select name="hasBuy" class="easyui-combobox" data-options="editable:false,onChange:function(){searchList()}">
  						<option value="">是否消费</option>
  						<option value="true">是</option>
  						<option value="false">否</option>
  					</select>
  				</td>
  				<td align="left" width="10%">
  					<select name="orderBy" class="easyui-combobox" data-options="editable:false,onChange:function(){searchList()}">
  						<option value="">请选择排序</option>
  						<option value="registertime desc">关注时间倒序</option>
  						<option value="memberpoint desc">积分倒序</option>
  						<option value="buycount desc">消费次数倒序</option>
  						<option value="lastbuytime desc">最近消费时间倒序</option>
  						<option value="totalmoney desc">累计消费金额倒序</option>
  					</select>
  				</td>
  				<td width="25%">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchList()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="dataTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
